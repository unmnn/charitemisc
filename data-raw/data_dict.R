library(dplyr)
library(tidyr)

dd_stem <-
  {
    tribble(
      ~item,          ~label,               ~description,
      # meta ----
      ".age",         "age",                "patient age",
      ".jour_nr",     ".jour_nr",           "patient ID",
      ".group",       ".group",             "meta: group",
      ".phase",       ".phase",             "phase",
      ".testdatum",   "Date",               "testing date",
      ".day",         "testing_day",        "testing date: day of the month",
      ".weekday",     "testing_weekday",    "testing date: day of the week",
      ".yearday", "testing_yearday", "testing date: day of the year",
      ".week", "testing_week", "testing date: calendar week",
      ".month", "testing_month", "testing date: month",
      # acsa ----
      "acsa_acsa", "ACSA_qualityoflife*", "Quality of life during the last 2 weeks",
      #paste0("Visuelle Analogskala zur Einschätzung der augenblicklichen Lebensqualität ",
      # "(0: schlimmste Zeit des Lebens, 10: schönste Zeit im Leben)")
      "acsa_acsa100", "ACSA_qualityoflife100", "Quality of life during the last 2 weeks",
      # adsl ----
      # English: http://www.valueoptions.com/providers/Education_Center/Provider_Tools/Depression_Screening.pdf
      "adsl_adsl_lk", "ADSL_lie", "Lie detection score",
      # score below -28 indicates that the answers are not trustworthy
      "adsl_adsl_sum", "ADSL_depression", "Depressive disorder sum score",
      "adsl_adsl_sum100", "ADSL_depression100", "Depressive disorder sum score",
      "adsl_adsl01", NA_character_, "\"During the past week I was bothered by things that usually don't bother me.\"",
      "adsl_adsl02", NA_character_, "\"During the past week I did not feel like eating; my appetite was poor.\"",
      "adsl_adsl03", NA_character_, "\"During the past week I felt that I could not shake off the blues even with help from my family or friends.\"",
      "adsl_adsl04", NA_character_, "\"During the past week I felt I was just as good as other people.\"",
      "adsl_adsl05", NA_character_, "\"During the past week I had trouble keeping my mind on what I was doing.\"",
      "adsl_adsl06", NA_character_, "\"During the past week I felt depressed.\"",
      "adsl_adsl07", NA_character_, "\"During the past week I felt that everything I did was an effort.\"",
      "adsl_adsl08", NA_character_, "\"During the past week I felt hopeful about the future.\"",
      "adsl_adsl09", NA_character_, "\"During the past week I thought my life had been a failure.\"",
      "adsl_adsl10", NA_character_, "\"During the past week I felt fearful.\"",
      "adsl_adsl11", NA_character_, "\"During the past week my sleep was restless.\"",
      "adsl_adsl12", NA_character_, "\"During the past week I was happy.\"",
      "adsl_adsl13", NA_character_, "\"During the past week I talked less than usual.\"",
      "adsl_adsl14", NA_character_, "\"During the past week I felt lonely.\"",
      "adsl_adsl15", NA_character_, "\"During the past week people were unfriendly.\"",
      "adsl_adsl16", NA_character_, "\"During the past week I enjoyed life.\"",
      "adsl_adsl17", NA_character_, "\"During the past week I had crying spells.\"",
      "adsl_adsl18", NA_character_, "\"During the past week I felt sad.\"",
      "adsl_adsl19", NA_character_, "\"During the past week I felt that people disliked me.\"",
      "adsl_adsl20", NA_character_, "\"During the past week I could not get going.\"",
      "adsl_timestamp", NA_character_, "ADSL: avg. time needed to fill an item (in secs)",
      # bi ----
      "bi_gbb01", NA_character_, "I feel bothered by feelings of weakness.",
      # "Erschöpfung - Schwächegefühl",

      "bi_gbb02", NA_character_, "I feel bothered by palpitation, tachycardia or allodromy.",
      # "Herzbeschwerden - Herzklopfen, Herzjagen oder Herzstolpern",

      "bi_gbb03", NA_character_, "I feel bothered by feelings of pressure or abdominal bloating.",
      # "Oberbauchschmerzen - Druck- oder Völlegefühl im Leib",

      "bi_gbb07", NA_character_, "I feel bothered by excessive need for sleep.",
      # "Erschöpfung - Übermäßiges Schlafbedürfnis",

      "bi_gbb09", NA_character_, "I feel bothered by joint pain or limb pain.",
      # "Gliederschmerzen - Gelenk- oder Gliederschmerzen",

      "bi_gbb10", NA_character_, "I feel bothered by vertigo.",
      # "Herzbeschwerden - Schwindelgefühl",

      "bi_gbb11", NA_character_, "I feel bothered by sacroiliac pain or backache.",
      # "Gliederschmerzen - Kreuz- oder Rückenschmerzen",

      "bi_gbb13", NA_character_, "I feel bothered by cervicalgia or shoulder pain.",
      # "Gliederschmerzen - Nacken- oder Schulterschmerzen",

      "bi_gbb15", NA_character_, "I feel bothered by vomition.",
      # "Oberbauchschmerzen - Erbrechen",
      "bi_gbb18", NA_character_, "I feel bothered by nausea.",
      # "Oberbauchschmerzen - Übelkeit",
      "bi_gbb20", NA_character_, "I feel bothered by globus sensation, pokiness or gagging.",
      # "Herzbeschwerden - Kloßgefühl, Engigkeit oder Würgen im Hals",
      "bi_gbb23", NA_character_, "I feel bothered by belching.",
      # "Oberbauchschmerzen - Aufstoßen",
      "bi_gbb25", NA_character_, "I feel bothered by heartburn or acid belching.",
      # "Oberbauchschmerzen - Sodbrennen oder saures Aufstoßen",
      "bi_gbb27", NA_character_, "I feel bothered by headache.",
      "bi_gbb29", NA_character_, "I feel bothered by rapid exhaustibility.",
      # "Erschöpfung - Rasche Erschöpfbarkeit"
      "bi_gbb32", NA_character_, "I feel bothered by fatigue.",
      # "Erschöpfung - Müdigkeit",
      "bi_gbb36", NA_character_, "I feel bothered by feelings of dizziness.",
      # "Erschöpfung - Gefühl der Benommenheit",
      "bi_gbb41", NA_character_, "I feel bothered by feelings of heaviness or tiredness in legs.",
      # "Gliederschmerzen - Schweregefühl oder Müdigkeit in den Beinen",
      "bi_gbb42", NA_character_, "I feel bothered by weariness.",
      # "Erschöpfung - Mattigkeit",
      "bi_gbb45", NA_character_, "I feel bothered by breast stitches or breast pain",
      # "Herzbeschwerden - Stiche, Schmerzen oder Ziehen in der Brust",
      "bi_gbb51", NA_character_, "I feel bothered by stomachache.",
      "bi_gbb52", NA_character_, "I feel bothered by asthma.",
      # "Herzbeschwerden - Anfallweise Atemnot"
      "bi_gbb55", NA_character_, "I feel bothered by feelings of pressure in my head.",
      # "Gliederschmerzen - Druckgefühl im Kopf",
      "bi_gbb56", NA_character_, "I feel bothered by attacks of heart trouble.",
      # "Herzbeschwerden - Anfallweise Herzbeschwerden",
      "bi_erschoepfung", "BI_fatigue", "Fatigue score",  # "Score Erschöpfung"
      "bi_magen", "BI_abdominalsymptoms", "Abdominal symptoms score",  # "Score Oberbauchschmerzen"
      # "bi_magen", "BI_epigastralgia", "Epigastralgia score",  # "Score Oberbauchschmerzen"
      "bi_glieder", "BI_limbpain", "Limb pain score",  # "Score Gliederschmerzen"
      "bi_herz", "BI_heartsymptoms", "Heart symptoms score",  #"Score Herzbeschwerden"
      # "bi_herz", "BI_cardiacpain", "Heart complaint score",  #"Score Herzbeschwerden"
      "bi_beschwerden", "BI_overallcomplaints", "Overall complaints sum score",  #"Score Gesamtbeschwerdedruck"
      "bi_timestamp", NA_character_, "BI: avg. time needed to fill an item (in secs)",
      # bsf ----
      "bsf_bsf01", NA_character_, "I feel faint.",
      # "Müdigkeit - matt",
      "bsf_bsf07", NA_character_, "I feel slack.",
      # "Müdigkeit - schlaff"
      "bsf_bsf11", NA_character_, "I feel tired.",
      # "Müdigkeit - müde",
      "bsf_bsf17", NA_character_, "I feel haggard.",
      # "Müdigkeit - abgespannt",
      "bsf_bsf29", NA_character_, "I feel exhausted.",
      # "Müdigkeit - erschöpft",
      "bsf_bsf04", NA_character_, "I feel indifferent.",
      # "Teilnahmslosigkeit - gleichgültig",
      "bsf_bsf09", NA_character_, "I feel uninvolved.",
      # "Teilnahmslosigkeit - unbeteiligt",
      "bsf_bsf16", NA_character_, "I feel bored.",
      # "Teilnahmslosigkeit - gelangweilt",
      "bsf_bsf22", NA_character_, "I feel apathetic.",
      # "Teilnahmslosigkeit - teilnahmslos",
      "bsf_bsf28", NA_character_, "I feel disinterested.",
      # "Teilnahmslosigkeit - uninteressiert",
      "bsf_bsf05", NA_character_, "I feel worried.",
      # "Ängstliche Depression - besorgt",
      "bsf_bsf12", NA_character_, "I feel concerned.",
      # "Ängstliche Depression - beunruhigt",
      "bsf_bsf23", NA_character_, "I feel insecure.",
      # "Ängstliche Depression - unsicher",
      "bsf_bsf24", NA_character_, "I feel depressed.",
      # "Ängstliche Depression - deprimiert",
      "bsf_bsf30", NA_character_, "I feel saddened.",
      # "Ängstliche Depression - betrübt",
      "bsf_bsf06", NA_character_, "I feel irritable.",
      # "Ärger - gereizt",
      "bsf_bsf08", NA_character_, "I feel belligerent.",
      # "Ärger - angriffslustig",
      "bsf_bsf14", NA_character_, "I feel edgy.",
      # "Ärger - kribbelig",
      "bsf_bsf19", NA_character_, "I feel angry.",
      "bsf_bsf21", NA_character_, "I feel aggressive.",
      # "Ärger - aggressiv",
      "bsf_bsf02", NA_character_, "I feel focused.",
      #"Engagement - konzentriert"
      "bsf_bsf13", NA_character_, "I feel deliberate.",
      # "Engagement - überlegt",
      "bsf_bsf18", NA_character_, "I feel sympathetic.",
      # "Engagement - verständnisvoll",
      "bsf_bsf25", NA_character_, "I feel helpful.",
      # "Engagement - hilfsbereit",
      "bsf_bsf27", NA_character_, "I feel considerate.",
      # "Engagement - aufmerksam",
      "bsf_bsf03", NA_character_, "I feel resolved.",
      # "Gehobene Stimmung - gelöst",
      "bsf_bsf10", NA_character_, "I feel cheerful.",
      # "Gehobene Stimmung - fröhlich",
      "bsf_bsf15", NA_character_, "I feel buoyant.",
      # "Gehobene Stimmung - heiter",
      "bsf_bsf20", NA_character_, "I feel balanced.",
      # "Gehobene Stimmung - ausgeglichen",
      "bsf_bsf26", NA_character_, "I feel jolly.",
      # "Gehobene Stimmung - vergnügt",
      "bsf_geh", "BSF_elevatedmood*", "Elevated mood score",  # "Score gehobene Stimmung"
      "bsf_eng", "BSF_mindset*", "Positive mindset score",  # "Score Engagement
      "bsf_aerg", "BSF_anger", "Anger score",  # Score Ärger
      "bsf_an_de", "BSF_anxdepression", "Anxious depression score",  #ängstliche Depressivität
      "bsf_mued", "BSF_fatigue", "Fatigue score",  # Score Müdigkeit
      "bsf_tnl", "BSF_apathy", "Apathy score",  # Score Teilnahmslosigkeit
      "bsf_timestamp", NA_character_, "BSF: avg. time needed to fill an item (in secs)",
      # isr ----
      # http://www.iqp-online.de/index.php?mact=Uploads,m0c712,getfile,1&m0c712upload_id=11&m0c712returnid=65&page=65
      # https://www.vr-elibrary.de/doi/pdf/10.13109/zptm.2008.54.4.409
      "isr_isr01", NA_character_, "I feel down and depressed.",
      "isr_isr02", NA_character_, "I no longer enjoy doing things I used to enjoy.",
      "isr_isr03", NA_character_, "When I want to do something I lack energy and get tired quickly.",
      "isr_isr04", NA_character_, "I lack self-esteem and no self-confidence.",
      "isr_isr05", NA_character_, "I suffer from inexplicable anxiety attacks or fear situations that seem harmless to others.",
      "isr_isr06", NA_character_, paste0("Feeling intense anxiety in such harmless situations, ",
                                         "I suffer physically from problems, such as rapid heartbeat, shortness of ",
                                         "breath, dizziness, chest pains, choking sensations, trembling, inner restlessness, or tension."),
      "isr_isr07", NA_character_, "I try to avoid these harmless frightening situations.",
      "isr_isr08", NA_character_, "Just thinking about a possible anxiety attack scares me.",
      "isr_isr09", NA_character_, "I suffer from recurring, seemingly senseless thoughts or actions which I cannot stop (such as excessive hand washing).",
      "isr_isr10", NA_character_, "I try to resist recurring, seemingly senseless thoughts and actions, but often don't succeed.",
      "isr_isr11", NA_character_, "I suffer from upsetting, seemingly pointless thoughts and actions which interfere with my everyday life.",
      "isr_isr12", NA_character_, "I feed the need to see a doctor about inexplicable physical problems.",
      "isr_isr13", NA_character_, "I constantly worry about having a serious physical illness.",
      "isr_isr14", NA_character_, "Several doctors have assured me that I'm not seriously ill, but I have a hard time believing them.  ",
      "isr_isr15", NA_character_, "I control my weight with low-calorie foods, by vomiting, with drugs (such as laxatives), or through extensive exercise.",
      "isr_isr16", NA_character_, "I think a lot about food and worry constantly about gaining weight.",
      "isr_isr17", NA_character_, "I spend a lot of time thinking of ways to lose weight.",
      "isr_isr18", NA_character_, "I have a difficult time concentrating.",
      "isr_isr19", NA_character_, "I think about committing suicide.",
      "isr_isr20", NA_character_, "I have problems sleeping.",
      "isr_isr21", NA_character_, "My appetite is diminished.",
      "isr_isr22", NA_character_, "I keep forgetting things.",
      "isr_isr23", NA_character_, "I suffer from recurring dreams or flashbacks of horrible events.",
      "isr_isr24", NA_character_, paste0("I have mental difficulties due to intense everyday stress ",
                                         "(such as being seriously ill, losing my job, or separating from my partner)."),
      "isr_isr25", NA_character_, "I no longer perceive my feelings and experiences as my own.",
      "isr_isr26", NA_character_, "The people and environment around me suddenly appear unreal, distant, and lifeless to me.",
      "isr_isr27", NA_character_, "I have difficulties engaging in sexual activities.",
      "isr_isr28", NA_character_, paste0("I've changed significantly over the past years after having experienced ",
                                         "an extremely stressful event (such as a head injury, a wartime experience, or abuse)."),
      "isr_isr29", NA_character_, "I have a problem with my sexual preferences.",
      "isr_deprsyn", "ISR_depression", "Depression score",
      "isr_angstsyn", "ISR_anxiety", "Anxiety score",
      "isr_zwasyn", "ISR_compulsivesyn", "Obsessive-compulsive syndrome score",
      "isr_somasyn", "ISR_somatosyn", "Somatoform syndrome score",
      "isr_essstsyn", "ISR_eatingdisorder", "Eating disorder score",
      "isr_zusatz", "ISR_additionalitems", "Additional items score",
      "isr_isr_ges", "ISR_totalpsychiatricsyn", "Total psychiatric syndrom score",
      "isr_timestamp", NA_character_, "ISR: avg. time needed to fill an item (in secs)",
      # phq ----
      # https://www.klinikum.uni-heidelberg.de/fileadmin/medizinische_klinik/Abteilung_2/pdf/JAMAphq1999.pdf
      "phqk_phqk_1a", NA_character_, "Little interest or pleasure in doing things (last 2 weeks)",
      "phqk_phqk_1b", NA_character_, "Feeling down, depressed, or hopeless (last 2 weeks)",
      "phqk_phqk_1c", NA_character_, "Trouble falling or staying asleep, or sleeping too much (last 2 weeks)",
      "phqk_phqk_1d", NA_character_, "Feeling tired or having little energy (last 2 weeks)",
      "phqk_phqk_1e", NA_character_, "Poor appetite or overeating (last 2 weeks)",
      "phqk_phqk_1f", NA_character_, "Feeling bad about yourself - or that you are a failure or have let yourself or your family down (last 2 weeks)",
      "phqk_phqk_1g", NA_character_, "Trouble concentrating on things, such as reading the newspaper or watching television (last 2 weeks)",
      "phqk_phqk_1h", NA_character_, paste0("Moving or speaking so slowly that other people could have noticed? Or the opposite - ",
                                            "being so fidgety or restless that you have been moving around a lot more than usual . (last 2 weeks)"),
      "phqk_phqk_1i", NA_character_, "Thoughts that you would be better off dead or of hurting yourself in some way. (last 2 weeks)",
      "phqk_phqk_2a", NA_character_, "In the last 4 weeks, have you had an anxiety attack — suddenly feeling fear or panic?",
      "phqk_phqk_2b", NA_character_, "Anxiety attack in the last 4 weeks: has this ever happened before?",

      "phqk_phqk_2c", NA_character_, paste0("Anxiety attack in the last 4 weeks: do some of these attacks come suddenly out of the blue",
                                            "- that is, in situations where you don't expect to be nervous or uncomfortable?"),

      "phqk_phqk_2d", NA_character_, "Anxiety attack in the last 4 weeks: do these attacks bother you a lot or are you worried about having another attack?",

      "phqk_phqk_2e", NA_character_, paste0("During your last bad anxiety attack, did you have symptoms likeshortness of breath, sweating, your heart racing ",
                                            "or pounding, dizzinessor faintness, tingling or numbness, or nausea or upsetstomach?"),

      "phqk_phqk_3", NA_character_, paste0("If you checked off any problems on this questionnaire so far, how difficult have these problems made it for you ",
                                           "to do your work, take care of things at home, or get along with other people?"),
      "phqk_depressivitaet", "PHQK_depression", "Presence of depression",
      "phqk_paniksyndrom", "PHQK_panicsyn", "Presence of panic syndrome",
      "phqk_timestamp", NA_character_, "PHQK: avg. time needed to fill an item (in secs)",
      # psq ----
      "psq_anfor100", "PSQ_demand100", "Demand score with range between 0 and 100",
      "psq_anford", "PSQ_demand", "Demand score",  # Anforderungen
      "psq_anspan", "PSQ_tension", "Tension score",
      "psq_anspan100", "PSQ_tension100", "Tension score with range between 0 and 100",
      "psq_freud100", "PSQ_joy100", "Joy score with range between 0 and 100",
      "psq_freude", "PSQ_joy*", "Joy score",
      "psq_sorg100", "PSQ_worries100", "Worries score with range between 0 and 100",
      "psq_sorgen", "PSQ_worries", "Worries score",
      "psq_psq_sum100", "PSQ_sum100", "Perceived stress sum score with range between 0 and 100",
      "psq_psq_sum", "PSQ_stress", "Total perceived stress sum score",
      "psq_stress01", NA_character_, "\"You feel rested.\"",
      "psq_stress02", NA_character_, "\"You feel that too many demands are being made on you.\"",

      "psq_stress03", NA_character_, "\"You are irritable or grouchy.\"",
      "psq_stress04", NA_character_, "\"You have too many things to do.\"",
      "psq_stress05", NA_character_, "\"You feel lonely or isolated.\"",
      "psq_stress06", NA_character_, "\"You find yourself in situations of conflict.\"",
      "psq_stress07", NA_character_, "\"You feel you're doing things you really like.\"",
      "psq_stress08", NA_character_, "\"You feel tired.\"",
      "psq_stress09", NA_character_, "\"You fear you may not manage to attain your goals.\"",

      "psq_stress10", NA_character_, "\"You feel calm.\"",
      "psq_stress11", NA_character_, "\"You have too many decisions to make.\"",
      "psq_stress12", NA_character_, "\"You feel frustrated.\"",
      "psq_stress13", NA_character_, "\"You are full of energy.\"",
      "psq_stress14", NA_character_, "\"You feel tense.\"",
      "psq_stress15", NA_character_, "\"Your problems seem to be piling up.\"",
      "psq_stress16", NA_character_, "\"You feel you're in a hurry.\"",
      "psq_stress17", NA_character_, "\"You feel safe and protected.\"",
      "psq_stress18", NA_character_, "\"You have many worries.\"",
      "psq_stress19", NA_character_, "\"You are under pressure from other people.\"",
      "psq_stress20", NA_character_, "\"You feel discouraged.\"",
      "psq_stress21", NA_character_, "\"You enjoy yourself.\"",
      "psq_stress22", NA_character_, "\"You are afraid for the future.\"",
      "psq_stress23", NA_character_, "\"You feel you're doing things because you have to not because you want to.\"",

      "psq_stress24", NA_character_, "\"You feel criticised or judged.\"",
      "psq_stress25", NA_character_, "\"You are lighthearted.\"",
      "psq_stress26", NA_character_, "\"You feel mentally exhausted.\"",
      "psq_stress27", NA_character_, "\"You have trouble relaxing.\"",
      "psq_stress28", NA_character_, "\"You feel loaded down with responsibility.\"",
      "psq_stress29", NA_character_, "\"You have enough time for yourself.\"",
      "psq_stress30", NA_character_, "\"You feel under pressure from deadlines.\"",
      "psq_timestamp", NA_character_, "PSQ: avg. time needed to fill an item (in secs)",
      # schmerzskal ----
      "schmerzskal_beein10", "SSKAL_painimpairment", "Visual analog scale pain impairment",
      "schmerzskal_staerke10", "SSKAL_painseverity", "Visual analog scale pain severity",
      "schmerzskal_haeuf10", "SSKAL_painfrequency", "Visual analog scale pain frequency",
      "schmerzskal_timestamp", NA_character_, "SSKAL: avg. time needed to fill an item (in secs)",
      # ses ----
      # http://www.meduniwien.ac.at/phd-iai/fileadmin/ISMED/Literaturhinweise/ISMEDPsychometrVerfahrenWUCHSE.pdf
      # https://edoc.ub.uni-muenchen.de/9398/1/Mueller_Evilin.pdf pg. 81
      "ses_ses01", NA_character_, "\"I perceive my pain as torturing.\"", # quälend
      "ses_ses02", NA_character_, "\"I perceive my pain as cruel.\"", # grausam
      "ses_ses03", NA_character_, "\"I perceive my pain as exhausting.\"", # erschöpfend
      "ses_ses04", NA_character_, "\"I perceive my pain as severe.\"", # heftig
      "ses_ses05", NA_character_, "\"I perceive my pain as murderous.\"", # mörderisch
      "ses_ses06", NA_character_, "\"I perceive my pain as miserable.\"", # elend
      "ses_ses07", NA_character_, "\"I perceive my pain as dreadful.\"", # schauderhaft
      "ses_ses08", NA_character_, "\"I perceive my pain as atrocious.\"", # scheußlich
      "ses_ses09", NA_character_, "\"I perceive my pain as heavy.\"", # schwer
      "ses_ses10", NA_character_, "\"I perceive my pain as unnerving.\"", # entnervend
      "ses_ses11", NA_character_, "\"I perceive my pain as devastating.\"", # maternd
      "ses_ses12", NA_character_, "\"I perceive my pain as awful.\"", # furchtbar
      "ses_ses13", NA_character_, "\"I perceive my pain as unbearable.\"", # unerträglich
      "ses_ses14", NA_character_, "\"I perceive my pain as paralyzing.\"", # lähmend
      "ses_ses15", NA_character_, "\"I perceive my pain as searing.\"", # schneidend
      "ses_ses16", NA_character_, "\"I perceive my pain as throbbing.\"", # klopfend
      "ses_ses17", NA_character_, "\"I perceive my pain as burning.\"", # brennend
      "ses_ses18", NA_character_, "\"I perceive my pain as ripping.\"", # reißend
      "ses_ses19", NA_character_, "\"I perceive my pain as thumping.\"", # pochend
      "ses_ses20", NA_character_, "\"I perceive my pain as glowing.\"", # glühend
      "ses_ses21", NA_character_, "\"I perceive my pain as stinging.\"", # stechend
      "ses_ses22", NA_character_, "\"I perceive my pain as hammering.\"", # hämmernd
      "ses_ses23", NA_character_, "\"I perceive my pain as hot.\"", # heiß
      "ses_ses24", NA_character_, "\"I perceive my pain as piercing.\"", # durchstoßend
      "ses_ses_affektiv", "SES_affectivepain", "Affective pain",
      "ses_ses_sensorisch", "SES_sensoricpain", "Sensoric pain",
      # sf8 ----
      # http://nerve.wustl.edu/SF-8%20Health%20Survey.pdf
      "sf8_sf01", NA_character_, "\"Overall, how would you rate your health during the past week?\"",
      "sf8_sf02", NA_character_, paste0("\"During the past 4 weeks, how much did physical health problems ",
                                        "limit your physical activities (such as walking or climbing stairs)?\""),
      "sf8_sf03", NA_character_, paste0("\"During the past 4 weeks, how much difficulty did you have ",
                                        "doing your daily work, both at home and away from home, ",
                                        "because of your physical health?\""),
      "sf8_sf04", NA_character_, "\"How much bodily pain have you had during the past 4 weeks?\"",
      "sf8_sf05", NA_character_, "\"During the past 4 weeks, how much energy did you have?\"",

      "sf8_sf06", NA_character_, paste0("\"During the past 4 weeks, how much did your physical ",
                                        "health or emotional problems limit your usual social ",
                                        "activities with family or friends?\""),

      "sf8_sf07", NA_character_, paste0("\"During the past 4 weeks, how much have you been bothered ",
                                        "by emotional problems (...) ?\""), #(such as feeling anxious, depressed or irritable)
      "sf8_sf08", NA_character_, paste0("\"During the past 4 weeks, how much did personal or emotional ",
                                        "problems keep you from doing your usual work, school or ",
                                        "other daily activities?\""),
      "sf8_bp_sf36ks", "SF8_bodilyhealth*", "Bodily health score",
      "sf8_gh_sf36ag", "SF8_overallhealth*", "Overall health score",
      "sf8_mcs8", "SF8_mentalcomp*", "Mental component summary score",
      "sf8_mh_sf36pw", "SF8_mentalhealth*", "Mental health score",
      "sf8_pcs8", "SF8_physicalcomp*", "Physical component summary score",
      "sf8_pf_sf36kf", "SF8_physicalfunct*", "Physical functioning score",
      "sf8_re_sf36er", "SF8_roleemotional*", "Role emotional score",
      "sf8_rp_sf36kr", "SF8_rolephysical*", "Role physical score",
      "sf8_sf_sf36sf", "SF8_socialfunct*", "Social functioning score",
      "sf8_vt_sf36vit", "SF8_vitality*", "Vitality score",
      "sf8_timestamp", NA_character_, "SF8: avg. time needed to fill an item (in secs)",
      # soc ----
      "soc_soc01", NA_character_, "Haben Sie das Gefühl, dass Sie in einer ungewohnten Situation sind und nicht wissen, was Sie tun sollen?",
      "soc_soc02", NA_character_, "Wenn Sie über Ihr Leben nachdenken, ist es dann sehr oft so, dass ...",
      "soc_soc03", NA_character_, "Die Dinge, die Sie täglich tun, sind für Sie ...",
      "soc_soc04", NA_character_, "Wie oft sind Ihre Gefühle und Gedanken ganz durcheinander?",
      "soc_soc05", NA_character_, "Wenn Sie etwas tun, das Ihnen ein gutes Gefühl gibt ...",
      "soc_soc06", NA_character_, "Sie erwarten für die Zukunft, dass Ihr eigenes Leben ...",
      "soc_soc07", NA_character_, paste0("Viele Leute - auch solche mit einem starken Charakter - fühlen sich in bestimmten Situationen als traurige Verlierer. ",
                                         "Wie oft haben Sie sich in der Vergangenheit so gefühlt?"),
      "soc_soc08", NA_character_, "Haben Sie das Gefühl, dass Sie in einer ungewohnten Situation sind und nicht wissen, was Sie tun sollen?",
      "soc_soc09", NA_character_, "Haben Sie das Gefühl, dass Sie in einer ungewohnten Situation sind und nicht wissen, was Sie tun sollen?",
      "soc_suskal", NA_character_, "soc total sense of coherence score",
      "soc_timestamp", NA_character_, "SOC: avg. time needed to fill an item (in secs)",
      # sozk ----
      "sozk_soz01_male", "SOZK_gender", "Male gender",
      "sozk_soz02_german", "SOZK_nationality", "German nationality",
      "sozk_soz05_partner", "SOZK_partnership", "In partnership",
      "sozk_soz06_divorced", "SOZK_divorced", "Divorced",
      "sozk_soz06_married", "SOZK_married", "Married",
      "sozk_soz06_unmarried", "SOZK_unmarried", "Unmarried",
      "sozk_soz09_abitur", "SOZK_abitur", "Education level: \"Abitur\"",
      "sozk_soz09_fachabitur", "SOZK_fachabitur", "Education level: \"Fachabitur\"",
      "sozk_soz09_hauptsch", "SOZK_lowersec", "Education level: lower secondary school",
      "sozk_soz09_mittlreife", "SOZK_mittlreife", "Education level: \"mittlere Reife\"",
      "sozk_soz10_geselle", "SOZK_geselle", "Education level: \"Geselle\"",
      "sozk_soz10_graduate", "SOZK_graduate", "Education level: university",
      "sozk_soz10_keinAbschl", "SOZK_nograd", "Education level: none",
      "sozk_soz10_meister", "SOZK_meister", "Education level: \"Meister\"",
      "sozk_soz10_schueazubi", "SOZK_pupil", "Education level: currently pupil or \"Azubi\"",
      "sozk_soz10_student", "SOZK_student", "Education level: currently student",
      "sozk_soz11_job", "SOZK_job", "Job status: currently employed",
      "sozk_soz1617_arblos", "SOZK_unemp", "Duration of unemployment in the last 5 years",
      "sozk_soz18_angest", "SOZK_employee", "Occupation: employee",
      "sozk_soz18_arbeiter", "SOZK_worker", "Occupation: worker",
      "sozk_soz18_beamter", "SOZK_civservant", "Occupation: civil servant",
      "sozk_soz18_selbstst", "SOZK_selfempl", "Occupation: self-employed",
      "sozk_soz18_other", "SOZK_occupother", "Occupation: other",
      "sozk_soz1920_krank", "SOZK_ill", "\"How long have you been ill during the last 12 months? (in months)\"",
      "sozk_soz21_tindauer", "SOZK_tinnitusdur", "\"How long have you been suffering from tinnitus (in years)?\"",
      "sozk_soz2224_psycho", "SOZK_psychotreat", "\"How long have you been in psychotherapeutic treatment? (in months)\"",
      "sozk_soz25_numdoc", "SOZK_nophysicians", "\"How many physicians have you visited because of your current complaints?\"",
      "sozk_timestamp", NA_character_, "SOZK: avg. time needed to fill an item (in secs)",
      # swop ----
      "swop_swo01", NA_character_, "\"If someone makes a stand against me, I will find ways to prevail.\"",
      # "Wenn mir jemand Widerstand leistet, finde ich Mittel und Wege, mich durchzusetzen."
      "swop_swo02", NA_character_, "\"I almost never expect things to go my way.\"",
      # "Ich erwarte fast nie, dass die Dinge nach meinem Sinn verlaufen.",
      "swop_swo03", NA_character_, "\"I have no trouble realizing my intentions and goals.\"",
      # "Es bereitet mir keine Schwierigkeiten, meine Absichten und Ziele zu verwirklichen.",
      "swop_swo04", NA_character_, "\"I am always optimistic about the future.\"",
      # "Ich blicke stets optimistisch in die Zukunft.",
      "swop_swo05", NA_character_, "\"I always know how to behave in unexpected situations.\"",
      # "In unerwarteten Situationen weiß ich immer, wie ich mich verhalten soll.",
      "swop_swo06", NA_character_, "\"Things never develop as I wish.\"",
      # "Die Dinge entwickeln sich nie so, wie ich es mir wünsche.",
      "swop_swo07", NA_character_, "\"Even with surprising events, I believe that I will get along well with it.\"",
      # "Auch bei überraschenden Ereignissen glaube ich, dass ich gut damit zurechtkommen werde.",
      "swop_swo08", NA_character_, "\"I can easily face difficulties because I can always rely on my abilities.\"",
      # "Schwierigkeiten sehe ich gelassen entgegen, weil ich mich immer auf meine Fähigkeiten verlassen kann.",
      "swop_swo09", NA_character_, "\"I always see the good side of things.\"",
      # "Ich sehe stets die guten Seite der Dinge.",
      "swop_sw", "SWOP_selfefficacy*", "Self-efficacy score",  # "Selbstwirksamkeitsscore"
      "swop_opt", "SWOP_optimism*", "Optimism score",  # Optimismusscore
      "swop_pes", "SWOP_pessimism", "Pessimism score",  # Pessimismus
      "swop_timestamp", NA_character_, "SWOP: avg. time needed to fill an item (in secs)",
      # tq ----
      # # English version: http://richardhallam.co.uk/Downloads/TinManREV5.pdf
      # # https://www.uniklinikum-saarland.de/fileadmin/UKS/Einrichtungen/Kliniken_und_Institute/
      # # Medizinische_Kliniken/Innere_Medizin_IV/Patienteninfo/Psychologe/FolienPsychotherapieBeiTinnitus.pdf
      "tq_aku", "TQ_auditoryperceptdiff", "Auditory perceptual difficulties score",
      "tq_co", "TQ_cognitivedistress", "Cognitive distress score",
      "tq_em", "TQ_emodistress", "Emotional distress score",
      "tq_inti", "TQ_intrusiveness", "Intrusiveness score",
      "tq_pb", "TQ_psychodistress", "Psychological distress score",
      "tq_sl", "TQ_sleepdisturbances", "Sleep disturbances score",
      "tq_som", "TQ_somacomplaints", "Somatic complaints score",
      # The German version of the TQ consists of 52 questions and the total sum score ranges from 0 (no distress) to 84 (very severe distress). The total score is based on 42 questions out of 52 and two questions are included twice. This questionnaire indicates the general level of tinnitus related psychological and psychosomatic distress. Factor analysis of the German version of the TQ revealed the factors emotional and cognitive distress, intrusiveness, auditory perceptual difficulties, sleep disturbances, and associated somatic complaints. According to its total score, the TQ is divided in four distress levels: mild (0–30), moderate (31–46), severe (47–59), very severe (60–84)
      # Items 6, 23, 24, 29, 30, 32, 40, 42, 45, 46, 49, 52 omitted (not necessary for scores)
      # Items 5, 20 used twice.
      "tq_tf", "TQ_distress", "Total tinnitus distress score",
      "tq_tin01", NA_character_, "\"I can sometimes ignore the noises even when they are there.\"",
      "tq_tin02", NA_character_, "\"I am unable to enjoy listening to music because of the noises.\"",
      "tq_tin03", NA_character_, "\"It's unfair that I have to suffer with my noises.\"",
      "tq_tin04", NA_character_, "\"I wake up more in the night because of my noises.\"",
      "tq_tin05", NA_character_, "\"I am aware of the noises from the moment I get up to the moment I sleep.\"",

      "tq_tin06", NA_character_, "\"Your attitude to the noise makes no difference to how it affects you.\"",

      "tq_tin07", NA_character_, "\"Most of the time the noises are fairly quiet.\"",
      "tq_tin08", NA_character_, "\"I worry that the noises will give me a nervous breakdown.\"",
      "tq_tin09", NA_character_, "\"Because of the noises I have difficulty in telling where sounds are coming from.\"",

      "tq_tin10", NA_character_, "\"The way the noises sound is really unpleasant.\"",
      "tq_tin11", NA_character_, "\"I feel I can never get away from the noises.\"",
      "tq_tin12", NA_character_, "\"Because of the noises I wake up earlier in the morning.\"",
      "tq_tin13", NA_character_, "\"I worry whether I will be able to put up with this problem for ever.\"",

      "tq_tin14", NA_character_, "\"Because of the noises it is more difficult to listen to several people at once.\"",

      "tq_tin15", NA_character_, "\"The noises are loud most of the time.",
      "tq_tin16", NA_character_, "\"Because of the noises I worry that there is something seriously wrong with my body.\"",

      "tq_tin17", NA_character_, "\"If the noises continue my life will not be worth living.\"",
      "tq_tin18", NA_character_, "\"I have lost some of my confidence because of the noises.\"",
      "tq_tin19", NA_character_, "\"I wish someone understood what this problem is like.\"",
      "tq_tin20", NA_character_, "\"The noises distract me whatever I am doing.\"",
      "tq_tin21", NA_character_, "\"There is very little one can do to cope with the noises.\"",
      "tq_tin22", NA_character_, "\"The noises sometimes give me a pain in the ear or head.\"",
      "tq_tin23", NA_character_, "\"When I feel low and pessimistic the noise seems worse.\"",

      "tq_tin24", NA_character_, "\"I am more irritable with my family and friends because of the noises.\"",
      "tq_tin25", NA_character_, "\"Because of the noises I have tension in the muscles of my head and neck.\"",
      "tq_tin26", NA_character_, "\"Because of the noises other people's voices sound distorted to me.\"",
      "tq_tin27", NA_character_, "\"It will be dreadful if these noises never go away.\"",
      "tq_tin28", NA_character_, "\"I worry that the noises might damage my physical health.\"",
      "tq_tin29", NA_character_, "\"The noise seems to go right through my head.\"",
      "tq_tin30", NA_character_, "\"Almost all my problems are caused by these noises.\"",
      "tq_tin31", NA_character_, "\"Sleep is my main problem.\"",
      "tq_tin32", NA_character_, "\"It's the way you think about the noise - NOT the noise itself which makes you upset.\"",

      "tq_tin33", NA_character_, "\"I have more difficulty following a conversation because of the noises.\"",
      "tq_tin34", NA_character_, "\"I find it harder to relax because of the noises.\"",
      "tq_tin35", NA_character_, "\"My noises are often so bad that I cannot ignore them.\"",
      "tq_tin36", NA_character_, "\"It takes me longer to get to sleep because of the noises.\"",
      "tq_tin37", NA_character_, "\"I sometimes get very angry when I think about having the noises.\"",
      "tq_tin38", NA_character_, "\"I find it harder to use the telephone because of the noises.\"",
      "tq_tin39", NA_character_, "\"I am more liable to feel low because of the noises.\"",
      "tq_tin40", NA_character_, "\"I am able to forget about the noises when I am doing something interesting.\"",
      "tq_tin41", NA_character_, "\"Because of the noises life seems to be getting on top of me.\"",
      "tq_tin42", NA_character_, "\"I have always been sensitive about trouble with my ears.\"",
      "tq_tin43", NA_character_, "\"I often think about whether the noises will ever go away.\"",
      "tq_tin44", NA_character_, "\"I can imagine coping with the noises.\"",
      "tq_tin45", NA_character_, "\"The noises never 'let up'.\"",
      "tq_tin46", NA_character_, "\"A stronger person might be better at accepting this problem.\"",
      "tq_tin47", NA_character_, "\"I am a victim of my noises.\"",
      "tq_tin48", NA_character_, "\"The noises have affected my concentration.\"",
      "tq_tin49", NA_character_, "\"The noises are one of those problems in life you have to live with.\"",
      "tq_tin50", NA_character_, "\"Because of the noises I am unable to enjoy the radio or television.\"",
      "tq_tin51", NA_character_, "\"The noises sometimes produce a bad headache.\"",
      "tq_tin52", NA_character_, "\"I have always been a light sleeper.\"",
      "tq_timestamp", NA_character_, "TQ: avg. time needed to fill an item (in secs)",
      # tinskal ----
      "tinskal_beein10", "TINSKAL_impairment", "Tinnitus impairment",
      "tinskal_beein100", "TINSKAL_impairment100", "Tinnitus impairment (scaled to a range from 0 to 100)",
      "tinskal_haeuf10", "TINSKAL_frequency", "Tinnitus frequency",
      "tinskal_haeuf100", "TINSKAL_frequency100", "Tinnitus frequency (scaled to a range from 0 to 100)",
      "tinskal_laut10", "TINSKAL_loudness", "Tinnitus loudness",
      "tinskal_laut100", "TINSKAL_loudness100", "Tinnitus loudness (scaled to a range from 0 to 100)",
      "tinskal_timestamp", NA_character_, "TINSKAL: avg. time needed to fill an item (in secs)",
      # tlq ----
      "tlq_tlq01_1", "TLQ_01_rightear", "Tinnitus location: right ear",
      "tlq_tlq01_2", "TLQ_01_leftear", "Tinnitus location: left ear",
      "tlq_tlq01_3", "TLQ_01_bothears", "Tinnitus location: both ears",
      "tlq_tlq01_4", "TLQ_01_entirehead", "Tinnitus location: entire head",
      "tlq_tlq01", "TLQ_tlq01", "The tinnitus is located...",
      "tlq_tlq02_1", "TLQ_02_whistling", "Tinnitus noise: whistling",
      "tlq_tlq02_2", "TLQ_02_hissing", "Tinnitus noise: hissing",  #(zischen)
      "tlq_tlq02_3", "TLQ_02_ringing", "Tinnitus noise: ringing",  #(klingeln)
      "tlq_tlq02_4", "TLQ_02_rustling", "Tinnitus noise: rustling",  #(rauschen)
      "tlq_tlq02", "TLQ_tlq02", "Tinnitus noise",
      "tlq_timestamp", NA_character_, "TLQ: avg. time needed to fill an item (in secs)"
    )
  }



dd_cats <- tribble(
  ~values, ~items,
  c(A = "admission (before treatment)", E = "discharge (after treatment)", V = "presentation"), ".phase",

  c(`0` = "rarely", `1` = "sometimes", `2` = "occasionally", `3` = "mostly"),
  c("adsl_adsl01", "adsl_adsl02", "adsl_adsl03", "adsl_adsl05", "adsl_adsl06",
    "adsl_adsl07", "adsl_adsl09", "adsl_adsl10", "adsl_adsl11", "adsl_adsl13",
    "adsl_adsl14", "adsl_adsl15", "adsl_adsl17", "adsl_adsl18", "adsl_adsl19",
    "adsl_adsl20"),

  c(`0` = "most", `1` = "occ.", `2` = "some", `3` = "rarely"),
  c("adsl_adsl04", "adsl_adsl08", "adsl_adsl12", "adsl_adsl16"),

  c(`0` = "not at\nall", `1` = "hardly", `2` = "somewhat",
    `3` = "consi-\nderably", `4` = "severely"),
  c("bi_gbb01", "bi_gbb02", "bi_gbb03", "bi_gbb07", "bi_gbb09", "bi_gbb10",
    "bi_gbb11", "bi_gbb13", "bi_gbb15", "bi_gbb18", "bi_gbb20", "bi_gbb23",
    "bi_gbb25", "bi_gbb27", "bi_gbb29", "bi_gbb32", "bi_gbb36", "bi_gbb41",
    "bi_gbb42", "bi_gbb45", "bi_gbb51", "bi_gbb52", "bi_gbb55", "bi_gbb56"),

  c(`0` = "not at\nall", `1` = "some-\nwhat", `2` = "rather",
    `3` = "mainly", `4` = "very\nmuch"),
  c("bsf_bsf01", "bsf_bsf07", "bsf_bsf11", "bsf_bsf17", "bsf_bsf29",
    "bsf_bsf04", "bsf_bsf09", "bsf_bsf16", "bsf_bsf22", "bsf_bsf28",
    "bsf_bsf05", "bsf_bsf12", "bsf_bsf23", "bsf_bsf24", "bsf_bsf30",
    "bsf_bsf06", "bsf_bsf08", "bsf_bsf14", "bsf_bsf19", "bsf_bsf21",
    "bsf_bsf02", "bsf_bsf13", "bsf_bsf18", "bsf_bsf25", "bsf_bsf27",
    "bsf_bsf03", "bsf_bsf10", "bsf_bsf15", "bsf_bsf20", "bsf_bsf26"),

  c(`0` = "does not apply", `1` = "applies a little",
    `2` = "applies quite a bit", `3` = "applies to a great extent",
    `4` = "applies extremely"),
  c("isr_isr01", "isr_isr02", "isr_isr03", "isr_isr04", "isr_isr05",
    "isr_isr06", "isr_isr07", "isr_isr08", "isr_isr09", "isr_isr10",
    "isr_isr11", "isr_isr12", "isr_isr13", "isr_isr14", "isr_isr15",
    "isr_isr16", "isr_isr17", "isr_isr18", "isr_isr19", "isr_isr20",
    "isr_isr21", "isr_isr22", "isr_isr23", "isr_isr24", "isr_isr25",
    "isr_isr26", "isr_isr27", "isr_isr28", "isr_isr29"),

  c(`0` = "not at all", `1` = "at some days",
    `2` = "more than half of the days", `3` = "almost every day"),
  c("phqk_phqk_1a", "phqk_phqk_1b", "phqk_phqk_1c", "phqk_phqk_1d",
    "phqk_phqk_1e", "phqk_phqk_1f", "phqk_phqk_1g", "phqk_phqk_1h",
    "phqk_phqk_1i"),

  c(`0` = "no", `1` = "yes"),
  c("phqk_phqk_2a",
    "sozk_soz01_male", "sozk_soz02_german", "sozk_soz05_partner",
    "sozk_soz06_divorced", "sozk_soz06_married", "sozk_soz06_unmarried",
    "sozk_soz09_abitur", "sozk_soz09_fachabitur", "sozk_soz09_hauptsch",
    "sozk_soz09_mittlreife", "sozk_soz10_geselle", "sozk_soz10_graduate",
    "sozk_soz10_keinAbschl", "sozk_soz10_meister", "sozk_soz10_schueazubi",
    "sozk_soz10_student", "sozk_soz11_job", "sozk_soz18_angest",
    "sozk_soz18_arbeiter", "sozk_soz18_beamter", "sozk_soz18_selbstst",
    "sozk_soz18_other",
    "tlq_tlq01_1", "tlq_tlq01_2", "tlq_tlq01_3", "tlq_tlq01_4",
    "tlq_tlq02_1", "tlq_tlq02_2", "tlq_tlq02_3", "tlq_tlq02_4"),

  c(`0` = "no", `1` = "yes", `9` = "not applicable"),
  c("phqk_phqk_2b", "phqk_phqk_2c", "phqk_phqk_2d", "phqk_phqk_2e"),

  c(`0` = "not difficult at all", `1` = "somewhat difficult",
    `2` = "very difficult", `3` = "extremely difficult"),
  c("phqk_phqk_3"),

  c(`1` = "hardly ever", `2` = "rarely", `3` = "frequently", `4` = "mostly"),
  c("psq_stress01", "psq_stress02", "psq_stress03", "psq_stress04",
    "psq_stress05", "psq_stress06", "psq_stress07", "psq_stress08",
    "psq_stress09", "psq_stress10", "psq_stress11", "psq_stress12",
    "psq_stress13", "psq_stress14", "psq_stress15", "psq_stress16",
    "psq_stress17", "psq_stress18", "psq_stress19", "psq_stress20",
    "psq_stress21", "psq_stress22", "psq_stress23", "psq_stress24",
    "psq_stress25", "psq_stress26", "psq_stress27", "psq_stress28",
    "psq_stress29", "psq_stress30"),

  c(`1` = "does not apply at all", `2` = "", `3` = "", `4` = "strongly applies"),
  c("ses_ses01", "ses_ses02", "ses_ses03", "ses_ses04", "ses_ses05",
    "ses_ses06", "ses_ses07", "ses_ses08", "ses_ses09", "ses_ses10",
    "ses_ses11", "ses_ses12", "ses_ses13", "ses_ses14", "ses_ses15",
    "ses_ses16", "ses_ses17", "ses_ses18", "ses_ses19", "ses_ses20",
    "ses_ses21", "ses_ses22", "ses_ses23", "ses_ses24"),

  c(`1` = "excellent", `2` = "very good", `3` = "good", `4` = "fair",
    `5` = "poor", `6` = "very poor"),
  c("sf8_sf01"),

  c(`1` = "not at all", `2` = "very little", `3` = "somewhat",
    `4` = "quite a lot", `5` = "could not do physical activities"),
  c("sf8_sf02"),

  c(`1` = "none at all", `2` = "a little bit", `3` = "some",
    `4` = "quite a lot", `5` = "could not do daily work"),
  c("sf8_sf03"),

  c(`1` = "none", `2` = "very mild", `3` = "mild",
    `4` = "moderate", `5` = "severe", `6` = "very severe"),
  c("sf8_sf04"),

  c(`1` = "very much", `2` = "quite a lot", `3` = "some",
    `4` = "a little", `5` = "none"),
  c("sf8_sf05"),

  c(`1` = "not at all", `2` = "very little", `3` = "somewhat",
    `4` = "quite a lot", `5` = "could not do social activities"),
  c("sf8_sf06"),

  c(`1` = "not at\nall", `2` = "slightly", `3` = "moder-\nately",
    `4` = "quite\na lot", `5` = "extremely"),
  c("sf8_sf07"),

  c(`1` = "not at all", `2` = "very little", `3` = "somewhat",
    `4` = "quite a lot", `5` = "could not do daily activities"),
  c("sf8_sf08"),

  c(`1` = "sehr oft", `2` = "", `3` = "", `4` = "", `5` = "", `6` = "",
    `7` = "sehr selten oder nie"),
  c("soc_soc01", "soc_soc04", "soc_soc07", "soc_soc09"),

  c(`1` = "Sie spüren, wie schön es ist, zu leben", `2` = "", `3` = "",
    `4` = "", `5` = "", `6` = "",
    `7` = "Sie fragen sich, wieso Sie überhaupt leben"),
  c("soc_soc02"),

  c(`1` = "eine Quelle tiefer Freude und Befriedigung", `2` = "", `3` = "",
    `4` = "", `5` = "", `6` = "",
    `7` = "eine Quelle von Schmerz und Langeweile"),
  c("soc_soc03"),

  c(`1` = "dann ist es bestimmt so, dass Sie sich auch weiterhin gut fühlen werden",
    `2` = "", `3` = "", `4` = "", `5` = "", `6` = "",
    `7` = "dann wird bestimmt etwas passieren, dass dieses Gefühl wieder verdirbt"),
  c("soc_soc05"),

  c(`1` = "ohne jeden Sinn und Zweck sein wird", `2` = "", `3` = "", `4` = "",
    `5` = "", `6` = "", `7` = "voller Sinn und Zweck sein wird"),
  c("soc_soc06"),

  c(`1` = "es Ihnen gelingen wird, die Schwierigkeiten zu überwinden",
    `2` = "", `3` = "", `4` = "", `5` = "", `6` = "",
    `7` = "Sie es nicht schaffen werden, die Schwierigkeiten zu überwinden"),
  c("soc_soc08"),

  c(`0` = "not jobless", `0.25` = "<1/2yr", `0.75` = "1/2-1yr",
    `1.5` = "1-2yrs", `2.5` = "2-3yrs", `4` = "3-5yrs"),
  c("sozk_soz1617_arblos"),

  c(`0` = "0", `1` = "1", `3.5` = "1-6", `9` = ">6"),
  c("sozk_soz1920_krank"),

  c(`0.25` = "<0.5", `0.75` = "0.5-1", `1.5` = "1-2", `3.5` = "2-5",
    `5` = ">5"),
  c("sozk_soz21_tindauer"),

  c(`0` = "0", `0.5` = "<1", `5.5` = "1-12", `12` = ">12"),
  c("sozk_soz2224_psycho"),

  c(`1` = "1", `2` = "2", `3` = "3", `4` = "4", `5` = "5", `6` = ">5"),
  c("sozk_soz25_numdoc"),

  c(`1` = "not true", `2` = "hardly true", `3` = "rather true",
    `4` = "very true"),
  c("swop_swo01", "swop_swo02", "swop_swo03", "swop_swo04", "swop_swo05",
    "swop_swo06", "swop_swo07", "swop_swo08", "swop_swo09"),

  c(`0` = "not true", `1` = "partly true", `2` = "true"),
  c("tq_tin01", "tq_tin02", "tq_tin03", "tq_tin04", "tq_tin05", "tq_tin06",
    "tq_tin07", "tq_tin08", "tq_tin09", "tq_tin10", "tq_tin11", "tq_tin12",
    "tq_tin13", "tq_tin14", "tq_tin15", "tq_tin16", "tq_tin17", "tq_tin18",
    "tq_tin19", "tq_tin20", "tq_tin21", "tq_tin22", "tq_tin23", "tq_tin24",
    "tq_tin25", "tq_tin26", "tq_tin27", "tq_tin28", "tq_tin29", "tq_tin30",
    "tq_tin31", "tq_tin32", "tq_tin33", "tq_tin34", "tq_tin35", "tq_tin36",
    "tq_tin37", "tq_tin38", "tq_tin39", "tq_tin40", "tq_tin41", "tq_tin42",
    "tq_tin43", "tq_tin44", "tq_tin45", "tq_tin46", "tq_tin47", "tq_tin48",
    "tq_tin49", "tq_tin50", "tq_tin51", "tq_tin52")
)

data_dict <- dd_stem %>%
  left_join(
    unnest(dd_cats, items),
    by = c("item" = "items")
  )

usethis::use_data(data_dict, overwrite = TRUE)

# datapasta::dpasta(dd_stem)
