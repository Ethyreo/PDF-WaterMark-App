import json
import os
import subprocess
import concurrent.futures

# The 176 IDs from the subagent
file_data = [
  {"id": "15GDBi2pk55w18_AkAElpF0-jtlTmW75Q", "name": "Mr. ABHAY.pdf"},
  {"id": "1sJtYF5tqQUQMXgTP_rmDrMQYsxk3cWsm", "name": "Mr. ABHIMANYU.pdf"},
  {"id": "12MKSIW1mrqTJWuOS0DrniztUs364Z88u", "name": "Mr. AJEET SINGH nimbus.pdf"},
  {"id": "1oX2uT0LoGh_HyIUdr96GJrALRk8OIXhf", "name": "Mr. ASHOK nimbus.pdf"},
  {"id": "11eA5pY-5V76cKpDDq41oK52gDOXsSikD", "name": "Mr. ASHOK.pdf"},
  {"id": "1dL8Wm9FEmYf3urUnPJepQMuG23aEJGGd", "name": "Mr. BALVEER SHARMA nimbus.pdf"},
  {"id": "1Eu7NTK8Ognh4eF5irnODfNzERK83XHdU", "name": "Mr. BHARAT BHUSHAN.pdf"},
  {"id": "1_OZlXwOIG2R23Hg0cO4LGZHgILI97wSS", "name": "Mr. BHIM DUTT.pdf"},
  {"id": "1MdgplcjsepWbMmCISMH6nWIQKfYoxG-m", "name": "Mr. CHANDER DEV.pdf"},
  {"id": "1CQW3mfys9JoTXMWJjcSHLBqGZCAu0X5d", "name": "Mr. CHANTER CHAUHAN.pdf"},
  {"id": "1OPINd8K5oxLX7IcVqTYMJCkVHORB3mYN", "name": "Mr. CHETAN CHAUHAN.pdf"},
  {"id": "1ABQhjuZ5_qnZhUvxwlBN8oIVTrktNAH7", "name": "Mr. DAYA NAND.pdf"},
  {"id": "1KNx_O10d3aaVEcmLpjLvBqzgxbrYwDx6", "name": "Mr. DAYA RAM nimbus.pdf"},
  {"id": "1n9AYVQbSw9GgswKiEl9xKmJgpqv_-ZaL", "name": "Mr. DEV RAJ (1).pdf"},
  {"id": "1Ed6zLlkqXFBC1NIbUf4XfWU1MBUajv2z", "name": "Mr. DEV RAJ (2).pdf"},
  {"id": "1PjWW1vIUg1rcr4g9uvRNXX7I0jHNyUJ2", "name": "Mr. DEV RAJ.pdf"},
  {"id": "1MDhPGdLVAZnDLnkWdFLN8jlLTnVGgaW1", "name": "Mr. DEVINDER SINGH.pdf"},
  {"id": "17KQlR9W_3FWd6fNzxUTuXVmr2HAZBVnm", "name": "Mr. DHARAMPAL.pdf"},
  {"id": "1Og0FHCoTytTRlgmOQfBc4eVMI_f3Jjm6", "name": "Mr. DILAWAR SINGH (1).pdf"},
  {"id": "1k2z0c9Ex2oEWz9CJzj0MOB6hKHY6oDI1", "name": "Mr. DILAWAR SINGH.pdf"},
  {"id": "1b42-YB-myHGe0bgs_rpoSTA3lGmupxP4", "name": "Mr. DILAWAR.pdf"},
  {"id": "1yXjdrvI51ew92teJg4_73z6Ma3hQhsoq", "name": "Mr. DURSA SINGH.pdf"},
  {"id": "1zvLesnten5gjs6t02gLhREVdGPqlvhF5", "name": "Mr. GAURAV CHAUHAN.pdf"},
  {"id": "1t5XU2uMK2_nXk0A4M12_ERvkiCFkm_xC", "name": "Mr. GOPAL SHARMA.pdf"},
  {"id": "1xt9kXGe1dL4EOmy1t4Flyxq6s95EVgKf", "name": "Mr. GOPINDER SINGH.pdf"},
  {"id": "1_hv_wOelq5-p7CnekIOOk_GHk1E6KOo9", "name": "Mr. HET RAM.pdf"},
  {"id": "117J0XXazUDLYp4iKopjOl4tzQgzBRHoB", "name": "Mr. INDER CHAUHAN.pdf"},
  {"id": "1UVvn_l_ERLLjIdrbGm7V5vlTQfMJXTky", "name": "Mr. INDERMANI nimbus.pdf"},
  {"id": "16JQLr2JBq3PtiRCGDfcxGo7WgWNwin48", "name": "Mr. ISHWAR DUTT nimbus.pdf"},
  {"id": "1O4LdLXqCytxYTQ6O5L9KiQnk9nwKJzZC", "name": "Mr. JAGMOHAN PUNDIR.pdf"},
  {"id": "11ozBxUUhd-F8T1SMP_tXi-qwEZv_KvPr", "name": "Mr. JAGMOHAN.pdf"},
  {"id": "1WlL1D7LSZSLD9mPlI-smL5-cx-pwXlhe", "name": "Mr. JALAM SINGH (1).pdf"},
  {"id": "1z7fwZquWODb6x71TrtyjcvwOLCStEg6f", "name": "Mr. JALAM SINGH.pdf"},
  {"id": "1Y8-DTV5Ms0cWk2TkYJsrMXUnuHAkKef4", "name": "Mr. JATIN nimbus.pdf"},
  {"id": "1eoz5_7NSY7SHp0KjhaVNn0PtF9AF20u7", "name": "Mr. JAY PAL.pdf"},
  {"id": "1JT_-vvwpiwn1584iv07fzfaeRHP7aIeQ", "name": "Mr. JAY RAM nimbus.pdf"},
  {"id": "1vVPDxZi6xTmxZqJTBc-BCU49qNoFE3XT", "name": "Mr. JITENDER SINGH nimbus.pdf"},
  {"id": "1N88e0GnPjevGNkTFhpp3bcAdFg-zRe79", "name": "Mr. JIYA  LEEL.pdf"},
  {"id": "1omv8Qwa7Y83qaE0DzYg84_Al337F2oT3", "name": "Mr. JOGENDER.pdf"},
  {"id": "1MkLlOLfNMC19A_BTObP4ioZmhj2uqgWy", "name": "Mr. KAILASH THAKUR.pdf"},
  {"id": "1_SBOPkh_4kX2TGseWEVAdYElgtmOAYAW", "name": "Mr. KAMAL KISHOR.pdf"},
  {"id": "1tHMyWalGnmcjYGOJ7hQHRh1cYZSTjOk0", "name": "Mr. KAMAL MAIN.pdf"},
  {"id": "1gjlsO2opRFjmQi182L60CWGYgjeFDO36", "name": "Mr. KAMAL SINGH.pdf"},
  {"id": "1aVXhzZNyYFH_A_mU0X6PwKaqzhLwojaC", "name": "Mr. KAMAL.pdf"},
  {"id": "15uc3HiA4cIwi1nk6EIb5X6Ohi5x09E5t", "name": "Mr. LACHMI DEVI.pdf"},
  {"id": "1rJkmXXWi5539-9gZSWO06uG2DM3i0cJA", "name": "Mr. MANISH.pdf"},
  {"id": "17b04Tymrm6QHbLOIBMCIY5MuC44AxUiN", "name": "Mr. MANOJ KUMAR.pdf"},
  {"id": "1eE6ppcVIxGQiUtkIEYzrFFlFp7i1irLr", "name": "Mr. MANOJ THAKUR.pdf"},
  {"id": "1su71Yub4p0CF1v8OYrAVUK7ONqyjdZBV", "name": "Mr. NARANJAN SINGH.pdf"},
  {"id": "11N29UJeNtYnR_F26ju9G0AJ02dDnRXDO", "name": "Mr. NARESH CHAUHAN.pdf"},
  {"id": "17BzQFxbaJ8TMNQf63EJcfr7nEk9mxSh4", "name": "Mr. NARPAL.pdf"},
  {"id": "1Q6DSxRFwTYu6JGFFyztP96SuX9tP_6bW", "name": "Mr. NARPAT SHARMA.pdf"},
  {"id": "1JAODy77vRRYpVqerxItlfugYgvEqCZbY", "name": "Mr. NIKHIL nimbus.pdf"},
  {"id": "1oCNHo-ZJ6IdWYiCazUILSpYoBuUI6Ih0", "name": "Mr. NISHANT nimbus.pdf"},
  {"id": "1X3YQuguLIa74xIvU792wcjKrMA7Dxj6y", "name": "Mr. PRADEEP KUMAR.pdf"},
  {"id": "1u4F3nOZE7YpK4nKKO7pv0jYHyPwv8eOu", "name": "Mr. PREM PAL.pdf"},
  {"id": "167O3YAr6D5QQo1WxB5IjT5ApdEg8Qs5Y", "name": "Mr. RAHUL.pdf"},
  {"id": "1KZ-smFOq5ESJf3IaHDZNi51Dq9pLOwCo", "name": "Mr. RAKESH THAKUR.pdf"},
  {"id": "1QC3j7Uy4DpiqYMRYehFBMUiRyopMiKF_", "name": "Mr. RAM LAL.pdf"},
  {"id": "12fsYorQ2uKWWempb-nWWP8gVM_Gvrh8v", "name": "Mr. RAMESH CHAND.pdf"},
  {"id": "16qMIL0KGBIn2jUiLK-iFOJ3p7lrsz1Y_", "name": "Mr. RANDHIR.pdf"},
  {"id": "1PRpy6M7lXYi6LGBQ5o4wMWTojKoxoO3H", "name": "Mr. RAVI PAL (1).pdf"},
  {"id": "1N5iC4HM2Anc8YWKldAOCzxtq3JU2Fadf", "name": "Mr. RAVI PAL.pdf"},
  {"id": "1S09HjWS_M73_V80AScdLwAf649vqameu", "name": "Mr. RAVINDER SINGH.pdf"},
  {"id": "149u-8dC_YDorJxbu7YuctCA08Jkb4QLm", "name": "Mr. RAVINDER.pdf"},
  {"id": "1VfEO0EbVYjmPVlWWewl3V4PGM-RY6-Wq", "name": "Mr. ROHIT nimbus.pdf"},
  {"id": "1hkeeuVtuSgP1oiQCamgoWRGcupKTwBa-", "name": "Mr. RUBESH.pdf"},
  {"id": "1ivE61AbTIUzBOaGSyE5eem0cDaJAxPFE", "name": "Mr. SATYA PAL (1).pdf"},
  {"id": "1nhwXg8jkxXrsTVcwBgK9fd63TbHSOwAn", "name": "Mr. SATYA PAL.pdf"},
  {"id": "1ySDfx-qs4sM-q0Ew5Qf5WTH4Un6HwX-d", "name": "Mr. SHER JUNG.pdf"},
  {"id": "1k77azCJ5Q35qKIDXW0xO0slXG6S6QeVw", "name": "Mr. SOOM DUTT.pdf"},
  {"id": "1CI8jbna6kMb6GP4nw4r1XAs7Mge-vk9v", "name": "Mr. SUBHASH CHAUHAN.pdf"},
  {"id": "1vvqkAinu5uERBDllAJksofOJrm7T9ccG", "name": "Mr. SUDESH.pdf"},
  {"id": "1RynzetRvDqNk59ZTzR2dCiobMCzijNyb", "name": "Mr. TAPENDER SINGH.pdf"},
  {"id": "1ppg13WiWuircoJ0fqEWFq2naAJf22qV8", "name": "Mr. TEJ NARAYAN SHARMA nimbus.pdf"},
  {"id": "1VvGob5FXRlMNT3o_KIp4rHHtp_Bat3g4", "name": "Mr. TUSHAR nimbus.pdf"},
  {"id": "1Qoxg59Ffaqy3xzhj4tR3IekTh8PY4Rk0", "name": "Mr. VICKY nimbus.pdf"},
  {"id": "1lZLP5JfAyWhGNfPavNS5Hr-C1if0wgfs", "name": "Mr. VIDYA DUTT.pdf"},
  {"id": "13geu7viQpTUQrwzphknHAYVgOM5MA3P3", "name": "Mr. VIJAY.pdf"},
  {"id": "1Y66JneLIleAsl015mRZoX5hQyQl_AtjL", "name": "Mr. VIJENDER SINGH nimbus.pdf"},
  {"id": "1idh65bEewkOmQvA06SIsYkQ_TT_EssT_", "name": "Mr. VIJENDER THAKUR.pdf"},
  {"id": "1T70XLues0qhy9Id4OswBLb9ITgMaHoXG", "name": "Mr. VIKRANT THAKUR.pdf"},
  {"id": "1SvB7tFGOD6UK5ylqxDV9rMZoGtOeqEOx", "name": "Mr. VINAY nimbus.pdf"},
  {"id": "1D8H3_Kvkc3uIt8mq2pt5_mPF6TAnBKvS", "name": "Mr. VINOD KUMAR.pdf"},
  {"id": "1oEJixG-1OpXl7fNjMIwtyBv-EhfcQaR3", "name": "Mr. VIRENDER CHAUHAN.pdf"},
  {"id": "1Igub6AxS7kMW1w66KAFn23raX76q35WI", "name": "Mr. VIVEK CHAUHAN nimbus.pdf"},
  {"id": "1dR1_lgHw0dpoJeHUwQUSoV6COcYEZG5R", "name": "Mrs. AMRA DEVI.pdf"},
  {"id": "18HHBKP1MQ4V-2k4-z_g8sVM94C1-orj6", "name": "Mrs. ANIL KUMARI.pdf"},
  {"id": "1xEPfdvy8rYdWhOQg935U0G7KWTZITPyn", "name": "Mrs. ANITA.pdf"},
  {"id": "1LUq5oEH4k0NlCnJVL_dnWBJK6v4yXlqI", "name": "Mrs. ARCHANA KANWAR.pdf"},
  {"id": "1NBKxwVgh4N9d2CvSOY0Fj2wChu4DIXQF", "name": "Mrs. ARTI.pdf"},
  {"id": "1tBYtJQG7-GawXmQ9TaxZ-yYhWrP3Jsnl", "name": "Mrs. ARUNA.pdf"},
  {"id": "136cLLjSQhJaLB5VRKCWLiLHmzhAAoKjg", "name": "Mrs. BANITA.pdf"},
  {"id": "1GsIFePpiR_NdsDnyT-ZBsJ12rsW1rU36", "name": "Mrs. BHAGWATI (1).pdf"},
  {"id": "1TiO1W4621xmpWcZc3cQA_k_yoCeAw_qR", "name": "Mrs. BHAGWATI.pdf"},
  {"id": "1GOpkkYxsJszoSf0KQikABSojPYWDb3EM", "name": "Mrs. CHINTA DEVI.pdf"},
  {"id": "1XtHheh6DS-qHKivGvLEs6fYv58WOel4M", "name": "Mrs. DAMYANTI DEVI.pdf"},
  {"id": "1PPZAXnlopzihOsIFL7umHW087uTnpeau", "name": "Mrs. DIPIKA nimbus.pdf"},
  {"id": "1zqYHD0eWOonEjs1v__oTGhRG7xlE7whF", "name": "Mrs. DURMA DEVI.pdf"},
  {"id": "1bCn5MUCBSZ6fCMQOzZAdRjAK-mFpp2nU", "name": "Mrs. GAGAN KUAMRI nimbus.pdf"},
  {"id": "1SLFDhTZKvet8C8-enf_bTnsJIJZb_AoC", "name": "Mrs. INDERA DEVI.pdf"},
  {"id": "1QH-Y7q-ZTR5RXrLp3Nzn1cgv-2NQxmRy", "name": "Mrs. JAIMANTI DEVI.pdf"},
  {"id": "1ISOT4GwCWu7IfHbRZZt6EjJp2Pkcinno", "name": "Mrs. JASHODA.pdf"},
  {"id": "1xAZ5s0D1gQxfBcaEeIDFyPdr4X7eUzHr", "name": "Mrs. KALA DEVI.pdf"},
  {"id": "1LHbRuiX-p_SMHlCB7GTkjJLqZVkXcqR9", "name": "Mrs. KAMLA.pdf"},
  {"id": "1UYMFLNrVV2yKf0xHYoUlRfJIqoZs7bKU", "name": "Mrs. KANKU DEVI.pdf"},
  {"id": "1UhZvwgEhQrwAhYq6a8H04hEWUafYEzuU", "name": "Mrs. KAUSHALYA CHAUHAN.pdf"},
  {"id": "1NyJgshh2IzqmDTFX9cy88HIY26ZrKxuV", "name": "Mrs. KIRAN (1).pdf"},
  {"id": "12hKi7-Wea0axIgaKC2TkoLAESKIt8HKu", "name": "Mrs. KIRAN (2).pdf"},
  {"id": "16x_dEKGbNfU0L5ur0owHTj_MqjjUxTWX", "name": "Mrs. KIRAN.pdf"},
  {"id": "10uPGe0n3nWQMloNTFE0-hXMJ4gRc5Q4c", "name": "Mrs. KRISHNA.pdf"},
  {"id": "1dyR8XjZ-t-RoCq2Up6TO7Kg7R3Qso4F5", "name": "Mrs. KUBJA DEVI (1).pdf"},
  {"id": "1XUc6-m3OIfLq_Ena00mvjdW-y5hG238P", "name": "Mrs. KUBJA DEVI.pdf"},
  {"id": "1xsEICV2HzUvvwQsEerGtZ6J4P-9sJqCl", "name": "Mrs. LAJWANTI.pdf"},
  {"id": "1O2CUWQ6lO9uovxbQILRDwu3JmhyzkuBs", "name": "Mrs. MADHU BALA.pdf"},
  {"id": "10eSI6buCx4QZ1I7_5AEYmV5230y3-caj", "name": "Mrs. MANJU BALA (1).pdf"},
  {"id": "1PYla1rOOVqzKOPt6BD9zpZVj0aO-0aDv", "name": "Mrs. MANJU BALA.pdf"},
  {"id": "1Ex_Je7GNgS-QD2cFhijdvBfpRzUoWhs1", "name": "Mrs. MEERA DEVI nimbus.pdf"},
  {"id": "1UWWrjoLtwFUExJAOjahdKOFzbDRQamK0", "name": "Mrs. MEERA KAMAL.pdf"},
  {"id": "19KkNi8DZs-Idjy4diNCW7fqSfi9FlMef", "name": "Mrs. MUNNI DEVI.pdf"},
  {"id": "1T9bbfOtYne0nkNiNPGjvtlApI5IV-8iL", "name": "Mrs. NEENA.pdf"},
  {"id": "1C6oVs8DGWteii968LwwB6nvencxkOg7O", "name": "Mrs. NIRMALA DEVI.pdf"},
  {"id": "17Xo112b1o2ncj3gS-ViY3sliGJuyqOG1", "name": "Mrs. NIRMALA nimbus.pdf"},
  {"id": "1u-OSAwNnhGURkB1rB-JaYA4V3CfctQAE", "name": "Mrs. PADMA DEVI (1).pdf"},
  {"id": "1VUAXnurUCGJrinetVo3xwnsq67xA9YHd", "name": "Mrs. PADMA DEVI.pdf"},
  {"id": "13ynGsz_QNKAV3nA9dsD0mok6n5qWTCCe", "name": "Mrs. PARIKSHA.pdf"},
  {"id": "1gXMuPu9jpwIr_zPqD1EdvggVW-K0Tf4r", "name": "Mrs. PAWAN.pdf"},
  {"id": "1vZS6o0-lhvbqs_WI4eLZzritbD6iyODc", "name": "Mrs. POOJA.pdf"},
  {"id": "1H_zSL4mDoew-ue-IIXSHAEUnLsH9IJqI", "name": "Mrs. POONAM (1).pdf"},
  {"id": "1pSKYE5GjkoN_l3A5Rj1jJE_RdpDE0aj5", "name": "Mrs. POONAM SHARMA.pdf"},
  {"id": "1d0ekjBMG1fA31l90mII3F_edGIHtl6Du", "name": "Mrs. POONAM THAKUR.pdf"},
  {"id": "1JoxMHnlrlbaYkCWjvPAWRWbFDyIjs0Yn", "name": "Mrs. POONAM.pdf"},
  {"id": "1nDsKioIXtQkU8_902govWifg0YTEInkj", "name": "Mrs. PREM DEVI.pdf"},
  {"id": "1JVRlAFbN7EVof-qGzfgsrebmnjwDIWbe", "name": "Mrs. RAKSHA DEVI.pdf"},
  {"id": "1t-UTaY5JYBaHrx8RTj4cTfNw6r0smZ2W", "name": "Mrs. REENA KUMARI.pdf"},
  {"id": "1nMltILR-5N0osRDnsWEqussLOWYOmXyc", "name": "Mrs. REENA.pdf"},
  {"id": "1ibVvKu-QyjVFw5GcbImlF0bEGo33yhbu", "name": "Mrs. REKHA SHARMA.pdf"},
  {"id": "1vdR04nnNCOeHcS2c7VzIawRPoMWHpUx_", "name": "Mrs. SAMTA DEVI nimbus.pdf"},
  {"id": "1ETdjmMCybwuzuYeVURjsvnoYwFr9x80D", "name": "Mrs. SANTOSH THAKUR.pdf"},
  {"id": "1p0dIHxG3NR1jqpYJgBZI7kRGJHE0KPTa", "name": "Mrs. SANTOSH.pdf"},
  {"id": "1lBKqN7JtRTzEM9qT7ZRFD_eV3OwqFvB9", "name": "Mrs. SAROJ BALA.pdf"},
  {"id": "1Y8SL-3W2nVmicXo4zhMTockxuMHNcQt4", "name": "Mrs. SATYA.pdf"},
  {"id": "1Y6-CCV_hMNe2xzMRooxq3Ynx_pG_eczX", "name": "Mrs. SAVITA THAKUR.pdf"},
  {"id": "1SWSxbyFetON4WaZSDVqrY_6Ox08_xu3v", "name": "Mrs. SAVITRI.pdf"},
  {"id": "1DSzj78yAcl5WlMCWDz8yknSMqfSsEP8h", "name": "Mrs. SEEMA DEVI (1).pdf"},
  {"id": "1b14WhHuHmpIKODSzOuCwnFemSAoeOvHJ", "name": "Mrs. SEEMA DEVI.pdf"},
  {"id": "1YV8YvzCi5iJvFsL7P2xC_P50HORmF_UW", "name": "Mrs. SHAKUNTALA.pdf"},
  {"id": "1NgU-KjbUpYEH0v0JTuEt6z0Q5I4_qbsx", "name": "Mrs. SHANTI DEVI.pdf"},
  {"id": "1ARNk1_gghP9Eda8MEjp_Yi3CKOCYr5x8", "name": "Mrs. SHARDA DEVI.pdf"},
  {"id": "1XPK24pYwio7FzbURKFoeCQpVzDMrwXwH", "name": "Mrs. SHEELA DEVI nimbus.pdf"},
  {"id": "1M_iDVs6Eq_w_RuEm86dHIKEGbUd1MzF-", "name": "Mrs. SHYAM LATA.pdf"},
  {"id": "1R17QeFUI75lMJT-Gj6QWBanV4y9s8rHn", "name": "Mrs. SHYAMA DEVI.pdf"},
  {"id": "1g0Mbl6wXbg3m6PF6Qudh7LBwwZp9Hn9d", "name": "Mrs. SHYMA nimbus.pdf"},
  {"id": "10O7HsGt4JX6QsTGXo34cgQtUAMKEu1zz", "name": "Mrs. SUBHDA DEVI nimbus.pdf"},
  {"id": "1biSglg7bV0aAbqKIqt-IxJ6etKUeROK2", "name": "Mrs. SUMAN THAKUR.pdf"},
  {"id": "13XC7KtYViLNTzjwPctxOXW4QZkaTEvNW", "name": "Mrs. SUMATI DEVI.pdf"},
  {"id": "182ymaQjj5zf1IsqnLV-7rtBStocHimlh", "name": "Mrs. SUNITA.pdf"},
  {"id": "1FYtviX0IQUwTOlTuHU6v4hobqEvXtIGf", "name": "Mrs. SUNPA DEVI.pdf"},
  {"id": "1pql_VpICnbevjbiNIzYVkDtiHCY3nVn4", "name": "Mrs. SURENDERA nimbus.pdf"},
  {"id": "1ji1a2JuMBLw34bOwxo4gpiDzcr0NTxKm", "name": "Mrs. SUSHILA nimbus.pdf"},
  {"id": "1ScTp4u_hWijGv401vD2D8YnwThYLxM6Q", "name": "Mrs. TARA DEVI (1).pdf"},
  {"id": "19r8Non_hvB6G2dm27WQC_qhnSW4QRy8o", "name": "Mrs. TARA DEVI.pdf"},
  {"id": "15QXTj8tEcA66PgmnmtzUp3IbGYazRAyk", "name": "Mrs. TOTA DEVI.pdf"},
  {"id": "1j1VQY7C8wSK5US_IfYCZm1YGp6YVlmZj", "name": "Mrs. VANDANA KUMARI.pdf"},
  {"id": "1NNAAM3HB17DNnoPdPotftaBPPmYYaAJ1", "name": "Mrs. VIJAY CHAUHAN.pdf"},
  {"id": "1e-1ge_e1Cqf7PcKnme2qYlJJzuBN819h", "name": "Ms. DEEPA KUMARI.pdf"},
  {"id": "15ObeV7pVcKgwvwcl5IQ6OUbVTo0M_WNT", "name": "Ms. MADHVI.pdf"},
  {"id": "1iq5nO2kOFQzDydHtAms1AvJQBCOMjYtX", "name": "Ms. MANSI nimbus.pdf"},
  {"id": "1sbxMV0eZ3yQFZpB9MXDUokPy9vBAIFXr", "name": "Ms. NANDHINI.pdf"},
  {"id": "1_-QOhQRXvL4kOBLiVAfaJfyY48Eo39xH", "name": "Ms. NITIKA THAKUR.pdf"},
  {"id": "1_KVBrn1KWG7R2uUOT094I2_xptJSzKuR", "name": "Ms. SANDIPIKA nimbus.pdf"},
  {"id": "1D9U4djTQnnPtUReW1996AeNwdOulhn5i", "name": "Ms. SHASHI PUNDIR nimbus.pdf"},
  {"id": "1SJRfTIKWtd4xIhp67C6zou_tHfC0tmcO", "name": "Ms. VINITA nimbus.pdf"},
  {"id": "1WAccBd9-5VA7DYGh5RxVBXQkqRdJjdKv", "name": "Nimbus Hospital.pdf"},
  {"id": "1r-M5dFbkOWa7aSy5gCOlxZEBiGlzIhoT", "name": "NISHA nimbus.pdf"},
  {"id": "1sCuVmIFChWcoglHgifvkypcFxnHYGJFN", "name": "RITIKA nimbus.pdf"}
]

output_dir = "/Users/gurman/Coding Projects/PDF_Watermarker/source_pdfs/Nimbus Report"
os.makedirs(output_dir, exist_ok=True)

gdown_executable = "/Users/gurman/Coding Projects/PDF_Watermarker/venv/bin/gdown"

def download_file(file_info):
    file_id = file_info["id"]
    file_name = file_info["name"]
    output_path = os.path.join(output_dir, file_name)
    
    # Skip if file already exists with a reasonable size (e.g. > 10KB)
    if os.path.exists(output_path) and os.path.getsize(output_path) > 10000:
        return f"Skipped existing: {file_name}"
        
    try:
        # Run gdown via subprocess for each file ID
        cmd = [gdown_executable, "--id", file_id, "-O", output_path]
        subprocess.run(cmd, capture_output=True, text=True, check=True)
        return f"Downloaded: {file_name}"
    except Exception as e:
        return f"Failed: {file_name} - {str(e)}"

if __name__ == "__main__":
    print(f"Starting concurrent download of {len(file_data)} files using gdown...")
    success_count = 0
    with concurrent.futures.ThreadPoolExecutor(max_workers=5) as executor:
        results = list(executor.map(download_file, file_data))
        
    for result in results:
        if "Downloaded" in result or "Skipped" in result:
            success_count += 1
            if "Downloaded" in result:
                print(result)
        else:
            print(result)
            
    print(f"\nDownload summary: {success_count}/{len(file_data)} successful.")
