#!/usr/bin/python
# -*- coding: utf-8 -*-

# taken from our isolinux gfxboot configuration
# gfxboot-theme-sabayon.git/langnames.inc
langs = [
    [ "am", "am_ET", "Amharic" ],
    [ "ar", "ar_EG", "Arabic" ],
    [ "ast", "ast_ES", "Asturianu" ],
    [ "be", "be_BY", "Беларуская" ],
    [ "bg", "bg_BG", "Български" ],
    [ "bn", "bn_BD", "Bengali" ],
    [ "bs", "bs_BA", "Bosanski" ],
    [ "ca", "ca_ES", "Català" ],
    [ "cs", "cs_CZ", "Čeština" ],
    [ "cy", "cy_GB", "Cymraeg" ],
    [ "da", "da_DK", "Dansk" ],
    [ "de", "de_DE", "Deutsch" ],
    [ "dz", "dz_BT", "Dzongkha" ],
    [ "el", "el_GR", "Ελληνικά" ],
    [ "en", "en_US", "English" ],
    [ "eo", "eo", "Esperanto" ],
    [ "es", "es_ES", "Español" ],
    [ "et", "et_EE", "Eesti" ],
    [ "eu", "eu_ES", "Euskara" ],
    [ "fi", "fi_FI", "Suomi" ],
    [ "fr", "fr_FR", "Français" ],
    [ "ga", "ga_IE", "Gaeilge" ],
    [ "gl", "gl_ES", "Galego" ],
    [ "gu", "gu_IN", "Gujarati" ],
    [ "he", "he_IL", "תירבע" ],
    [ "hi", "hi_IN", "Hindi" ],
    [ "hr", "hr_HR", "Hrvatski" ],
    [ "hu", "hu_HU", "Magyar" ],
    [ "id", "id_ID", "Bahasa Indonesia" ],
    [ "it", "it_IT", "Italiano" ],
    [ "ja", "ja_JP", "日本語" ],
    [ "ka", "ka_GE", "ქართული" ],
    [ "kk", "kk_KZ", "Қазақ" ],
    [ "km", "km_KH", "Khmer" ],
    [ "ko", "ko_KR", "한국어" ],
    [ "ku", "ku_TR", "Kurdî" ],
    [ "lt", "lt_LT", "Lietuviškai" ],
    [ "lv", "lv_LV", "Latviski" ],
    [ "mk", "mk_MK", "Македонски" ],
    [ "ml", "ml_IN", "Malayalam" ],
    [ "mr", "mr_IN", "Marathi" ],
    [ "ne", "ne_NP", "Nepali" ],
    [ "nl", "nl_NL", "Nederlands" ],
    [ "nb", "nb_NO", "Norsk bokmål" ],
    [ "nn", "nn_NO", "Norsk nynorsk" ],
    [ "pa", "pa_IN", "Punjabi (Gurmukhi)" ],
    [ "pl", "pl_PL", "Polski" ],
    [ "pt_BR", "pt_BR", "Português do Brasil" ],
    [ "pt_PT", "pt_PT", "Português" ],
    [ "ro", "ro_RO", "Română" ],
    [ "ru", "ru_RU", "Русский" ],
    [ "se", "se_NO", "Sámegillii" ],
    [ "sk", "sk_SK", "Slovenčina" ],
    [ "sl", "sl_SI", "Slovenščina" ],
    [ "sq", "sq_AL", "Shqip" ],
    [ "sr", "sr_RS", "Српски" ],
    [ "sv", "sv_SE", "Svenska" ],
    [ "ta", "ta_IN", "Tamil" ],
    [ "th", "th_TH", "Thai" ],
    [ "tl", "tl_PH", "Tagalog" ],
    [ "tr", "tr_TR", "Türkçe" ],
    [ "uk", "uk_UA", "Українська" ],
    [ "vi", "vi_VN", "Tiếng Việt" ],
    [ "wo", "wo_SN", "Wolof" ],
    [ "zh_CN", "zh_CN", "中文(简体)" ],
    [ "zh_TW", "zh_TW", "中文(繁體)" ],
]

keymaps = [
    [ "af", "Afghanistan"],
    [ "al", "Albania"],
    [ "ad", "Andorra"],
    [ "ara", "Arabic"],
    [ "am", "Armenia"],
    [ "es_ast", "Asturian"],
    [ "az", "Azerbaijan"],
    [ "bd", "Bangladesh"],
    [ "by", "Belarus"],
    [ "be", "Belgium"],
    [ "bt", "Bhutan"],
    [ "ba", "Bosnia"],
    [ "br", "Brazil"],
    [ "bg", "Bulgaria"],
    [ "kh", "Cambodia"],
    [ "ca", "Canada"],
    [ "es_cat", "Catalan"],
    [ "cn", "China"],
    [ "cd", "Congo"],
    [ "hr", "Croatia"],
    [ "cz", "Czechia"],
    [ "dk", "Denmark"],
    [ "us_dvorak", "Dvorak"],
    [ "epo", "Esperanto"],
    [ "ee", "Estonia"],
    [ "et", "Ethiopia"],
    [ "fo", "Faroes"],
    [ "fi", "Finland"],
    [ "fr_oss", "France"],
    [ "ge", "Georgia"],
    [ "de", "Germany"],
    [ "gh", "Ghana"],
    [ "gr", "Greece"],
    [ "gn", "Guinea"],
    [ "in_guj", "Gujarati"],
    [ "in_guru", "Gurmukhi"],
    [ "hu", "Hungary"],
    [ "is", "Iceland"],
    [ "in", "India"],
    [ "ir", "Iran"],
    [ "iq", "Iraq"],
    [ "ie", "Ireland"],
    [ "il", "Israel"],
    [ "it", "Italy"],
    [ "jp", "Japan"],
    [ "in_kan", "Kannada"],
    [ "kz", "Kazakhstan"],
    [ "kr", "Korea"],
    [ "tr_ku", "Kurdish"],
    [ "kg", "Kyrgyzstan"],
    [ "la", "Laos"],
    [ "latam", "Latin Amer."],
    [ "lv", "Latvia"],
    [ "lt", "Lithuania"],
    [ "mk", "Macedonia"],
    [ "in_mal", "Malayalam"],
    [ "mv", "Maldives"],
    [ "mt", "Malta"],
    [ "mao", "Maori"],
    [ "mn", "Mongolia"],
    [ "me", "Montenegro"],
    [ "ma", "Morocco"],
    [ "mm", "Myanmar"],
    [ "np", "Nepal"],
    [ "nl", "Netherlands"],
    [ "ng", "Nigeria"],
    [ "no", "Norway"],
    [ "pk", "Pakistan"],
    [ "pl", "Poland"],
    [ "pt", "Portugal"],
    [ "ro", "Romania"],
    [ "ru", "Russia"],
    [ "fi_smi", "Saami (Fin.)"],
    [ "no_smi", "Saami (Nor.)"],
    [ "se_smi", "Saami (Swe.)"],
    [ "sn", "Senegal"],
    [ "rs", "Serbia"],
    [ "sk", "Slovakia"],
    [ "si", "Slovenia"],
    [ "za", "South Africa"],
    [ "es", "Spain"],
    [ "lk", "Sri Lanka"],
    [ "se", "Sweden"],
    [ "ch_fr", "Swiss French"],
    [ "ch", "Swiss German"],
    [ "sy", "Syria"],
    [ "tj", "Tajikistan"],
    [ "in_tam", "Tamil"],
    [ "in_tel", "Telugu"],
    [ "th", "Thailand"],
    [ "tr", "Turkey (Q)"],
    [ "tr_f", "Turkey (F)"],
    [ "tm", "Turkmenistan"],
    [ "gb", "English UK"],
    [ "us", "USA"],
    [ "us_intl", "USA Intl."],
    [ "ua", "Ukraine"],
    [ "uz", "Uzbekistan"],
    [ "vn", "Vietnam"],
]

print("""\
submenu "Language Selection" {
""")

for shortlang, lang, name in langs:
    print("""\
   menuentry "%(name)s" {
      echo "Switching to: $chosen"
      set lang=%(lang)s
      set bootlang=%(lang)s
      export bootlang
      export lang
      configfile /boot/grub/grub.cfg
   }
""" % {'name': name, 'lang': lang,})

print("""\
}
""")

print("""\
submenu "Keyboard Selection" {
""")

for keymap, name in keymaps:
    print("""\
   menuentry "%(name)s" {
      echo "Switching to: $chosen"
      set bootkeymap=%(keymap)s
      export bootkeymap
      configfile /boot/grub/grub.cfg
   }
""" % {'name': name, 'keymap': keymap,})

print("""\
}
""")
