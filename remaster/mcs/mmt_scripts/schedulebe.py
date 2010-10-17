#!/usr/bin/python
# schedulebe (c) robipolli@gmail.com
# a postfix plugin for managing events in python
# License: GPL2
#
#
# this software manage mail meeting invitation, 
# notifying to  bedework  
# *  meeting request to bedework users
# *  meeting replies    
# takes a mail from stdin
# check if it's a meeting request/reply
# get header from mail
# use them to make a POST request to bedework RTSVC
#
import StringIO
import vobject
import email, httplib
import re
import pycurl
import sys, getopt
from xml.dom import minidom
from xml.parsers.expat import ExpatError

_debug = False
#rtsvcUrl = "http://caladminurl"
#rtsvcUrl = "http://pubcaladminurl"
rtsvcUrl = None
conf_request_enabled = True
conf_mail_enabled = True

# rtsvcUser = "user1"
# rtsvcPass = "user2"

class Meeting:

    def __init__(self):
        self.ics = None
        self.method = None
        self.organizer = None
        self.attendees = []
        
        self.sender = None
        self.recipient = []
        
    def setMail(self, mailMessage):
        self.walkMail(mailMessage)
                               
    def getMethod(self):
        return self.ics.method.value
    
    def getOrganizer(self):
        # TODO check organizer ~= /mailto:/
        o =  cleanMailAddress(self.ics.vevent.organizer.value) 
        return o
    
    def getAttendees(self):
        if len(self.attendees) == 0:
            for a in self.ics.vevent.__getattr__("attendee_list"):
                self.attendees.append(cleanMailAddress(a.value))
                
        return self.attendees



    def validate(self):
        
        if conf_request_enabled and self.getMethod() == "REQUEST":
            #mail recipient must be internal and in attendees
            # in a meeting request, organizer is the mail sender
            if self.getOrganizer() != self.sender:
                if _debug:
                    print "in %s: Organizer != sender : %s != %s"  % (self.getMethod(), self.getOrganizer(), self.sender)
                return False
            
        elif self.getMethod() == "REPLY":
            #the sender mail should be one of the attendees
            if not self.sender in self.getAttendees():
                if _debug:
                    print "in %s: sender != attendees : %s not contains  %s"  % (self.getMethod(),self.getAttendees(), self.sender)
                return False
            
        else:
            print "Error validating meeting"

        return True
        # check that organizer is valid
#        if not __checkOrganizer(self.getOrganizer()):
#            return False
   
    def walkMail(self, mailMessage):
        """walk thru the mail looking for calendar attachment"""
        """parse attachment and set meeting.ics"""

        self.sender = cleanMailAddress(mailMessage['From'])
        for rcpt in mailMessage['To'].split(","):
            self.recipient.append(cleanMailAddress(rcpt))
            
        if _debug:
            print "DEBUG: from: %s, rcpt: %s" % (mailMessage['From'], mailMessage['To'])
            
        mailWalker = mailMessage.walk()
        try:
            for i in mailWalker:
                if i.get_content_type() == "text/calendar": 
                    if self != None:  
                        icalendar = vobject.readOne(i.get_payload(decode=True))
                        self.ics = icalendar
                    else:
                        if _debug:
                            print "Test case: %s" % i.get_payload(decode=True)
        except vobject.base.ParseError:
            print "Error while parsing calendar"
            raise           
        
         
#end class
def __checkOrganizer(organizer):
    """check if organizer is an user of the platform"""

    return True      
        
def getMeetingInfo(meeting):
    """get meeting info """
    """ TODO http://docs.python.org/library/email.html#module-email"""
    meeting.method = meeting.ics.method.value
    meeting.organizer = meeting
    return meeting.method.value



def cleanMailAddress(mailaddress):
    """clean the mail address returning a string value (no unicode)"""
    s = re.compile('^.*<(.+)>.*',re.IGNORECASE).sub(r'\1', mailaddress)
    s = re.compile('mailto:',re.IGNORECASE).sub(r'', s)
    return str(s.lower())
    
def getRecipientsFromMail(mail):
    """get the TO Header from the email"""
    recipients = ["one@example.com","two@exmaple.com"]
    recipient = mail['To']
    return recipients

def sendRequestToBedework(meeting):        
    """send a POST request to RTSVC url, setting    """
    """    Header: originator: me@gmail.com         """
    """    Header: recipient:  one@example.com      """
    """    Header: recipient:  two@example.com      """
    """    Header: Content-type: text/calendar      """
    """    .ics as POST body                        """
    if not meeting.validate():
        return False
    
    rtsvcHeader = [ 'Content-Type:text/calendar; charset=UTF-8' ]
    rtsvcHeader.append('originator: ' + meeting.sender)
    
    if conf_mail_enabled:
	    rcptList = []
	    
	    if meeting.getMethod() == "REQUEST":
	        rcptList = set(meeting.getAttendees()).intersection(meeting.recipient)
	    elif meeting.getMethod() == "REPLY":
	        rcptList.append(meeting.getOrganizer())
	        rcptList = set(rcptList).intersection(meeting.recipient)
	        
	    for a in rcptList:
        	rtsvcHeader.append('recipient: ' + a)    
                
    c = pycurl.Curl()
 
    if _debug:
        print "DEBUG:" + meeting.ics.serialize()
        # c.setopt(c.VERBOSE, 1)
        for a in rtsvcHeader: print "DEBUG:" + a
        
    output = StringIO.StringIO()
    
    c.setopt(c.HTTPHEADER, rtsvcHeader)   
    c.setopt(c.POSTFIELDS, meeting.ics.serialize())
    c.setopt(c.URL, rtsvcUrl)
    c.setopt(c.HEADER, 1)
    c.setopt(c.POST, 1)
    c.setopt(pycurl.WRITEFUNCTION, output.write)

    res = c.perform()
    if _debug:
        # print output
        print """DEBUG request %d """ % c.getinfo(pycurl.HTTP_CODE)
    

    #response = output.read()
    response = output.getvalue()
    if _debug:
        print "DEBUG: response: [%s]" % response

    parseResponse(response)
        
    return True

def parseRecipientResponse(response):
    """return True if the scheduling request to the recipient is successful
      <ns1:response>
        <ns1:recipient>
          <href>attendee@mysite.edu</href>
        </ns1:recipient>
        <ns1:request-status>2.0;Success</ns1:request-status>
      </ns1:response>    
    """
    if response.localName != 'response':
        return False
    
    for walk in response.childNodes:
        if walk.localName == 'recipient':
            attendees = walk.getElementsByTagName('href')
            attendee = attendees[0].childNodes[0].data
                
        elif walk.localName == 'request-status':
            if _debug:
                print "REPORT: attendee: %s\t\tstatus: %s" % (attendee, walk.childNodes[0].data)
                
            v = {'2.0;Success'  : True,
                 '1.0;Deferred' : True,
                 'default' : False                
                 }
            
            return v.get(walk.childNodes[0].data, 'default')
            
            
    # false by default  
    return False

def parseResponse(response):
    """Parse the xml response of the RTSVC server
    The response is like:
    HttpHeaders
    ...
    <?xml version="1.0" encoding="UTF-8" ?>
        <ns1:schedule-response xmlns="DAV:" xmlns:ns1="urn:ietf:params:xml:ns:caldav" xmlns:ns2="http://www.w3.org/2002/12/cal/ical#">
          <ns1:response>
            <ns1:recipient>
              <href>attendee@mysite.edu</href>
            </ns1:recipient>
            <ns1:request-status>2.0;Success</ns1:request-status>
          </ns1:response>
        </ns1:schedule-response>
    """
    ret = False
    
    # strip http headers
    try:
        response = response[response.index('<'):]
    except ValueError:
        print "DEBUG: Can't find < in response"
        return False
    
    #support multiple xml documents in response
    for singleResponse in response.split('\n<?xml'):
        if len(singleResponse) <= 5:
            if _debug:
                print "skipping short response" + singleResponse
            continue
        
        try:
            doc = minidom.parseString(singleResponse)
            for walk in doc.childNodes:
                if walk.localName == 'schedule-response':
                    for resp in walk.getElementsByTagName(walk.prefix + ':response'):
                        ret = parseRecipientResponse(resp)

        except ExpatError:
            print "Errore nella stringa [%s] " % singleResponse
            raise
            ret = False
          
    return ret      


def __notifyUpdate(isError):
    """notify the user that bedework has been nicely updated"""
    if isError:
        return False
    
    return True



def countEnum(i):
    tot=0
    for j in i:
        tot = tot+1
    return tot


def usage():
    print "usage: schedulebe -U [-v][-h][-f file][-u[-p]]"             

def main():
    # parse command line options
    try:
        #sys.argv[1:] strip the first argument from sys.argv[]
        opts, args = getopt.getopt(sys.argv[1:], "hvf:U:u:p:", ["help", "verbose", "file", "URL", "username", "password"])
    except getopt.error, msg:
        print msg
        print "for help use --help"
        sys.exit(2)

    file = None
    url = None
    username = None
    password = None
    
    for opt,arg in opts:
        if opt in ("-h", "--help"):
            usage()
            sys.exit()
        elif opt == '-v':
            global _debug
            _debug = True
        elif opt in ("-f", "--file" ):
	    file = arg
	elif opt in ("-U", "--URL"):
	    url = arg
	elif opt in ("-u", "--username"):
   	    username = arg
	elif opt in ("-p", "--password"):
  	    password = arg
	    
    if (url == None) or (username != None and password == None) or (username == None and password != None):
        print url
        usage()
	sys.exit()

    if url.find("://") == -1:
        print "bad url"
	usage()
	sys.exit(2)

    global rtsvcUrl
    if username != None and password != None:
        schema, address = url.split("://")
        rtsvcUrl = schema + "://" + username + ":" + password + "@" + address
    else:
        rtsvcUrl = url

    try:
        if file==None:
            fd=sys.stdin
        else:
            fd = open(file)
            
        m = Meeting()
        m.setMail(email.message_from_string(fd.read()))
        
            
        organizer = m.getOrganizer()
        recipients = m.getAttendees()
        
        if _debug:
            print "organizer :%s\nattendees:%s\n" % (organizer, recipients)
        
        if (__checkOrganizer(organizer)):
            if (sendRequestToBedework(m)):
                print "calendar event synchronized"
                return True

    except IOError:
        print "error: file not found"
        sys.exit(2)
    except:
        print "error: No ics found"

        sys.exit(2)


# if it's standalone, exec
if __name__ == "__main__":
    main()

    
