


//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

var/list/preferences_datums = list()


var/global/list/special_roles = list( //keep synced with the defines BE_* in setup.dm --rastaf
//some autodetection here.
	"traitor" = IS_MODE_COMPILED("traitor"),             // 0
	"operative" = IS_MODE_COMPILED("nuclear"),           // 1
	"changeling" = IS_MODE_COMPILED("changeling"),       // 2
	"wizard" = IS_MODE_COMPILED("wizard"),               // 3
	"malf AI" = IS_MODE_COMPILED("malfunction"),         // 4
	"revolutionary" = IS_MODE_COMPILED("revolution"),    // 5
	"alien candidate" = 1, //always show                 // 6
	"positronic brain" = 1,                              // 7
	"cultist" = IS_MODE_COMPILED("cult"),                // 8
	"infested monkey" = IS_MODE_COMPILED("monkey"),      // 9
	"ninja" = "true",                                    // 10
	"vox raider" = IS_MODE_COMPILED("heist"),            // 11
	"diona" = 1,                                         // 12
	"mutineer" = IS_MODE_COMPILED("mutiny"),             // 13
	"pAI candidate" = 1, // -- TLE                       // 14
	//"ghost hunter" = IS_MODE_COMPILED("ghostbusters"),   // 15
	//"master of dreams" = IS_MODE_COMPILED("daemon")     // 16
)

//used for alternate_option
#define GET_RANDOM_JOB 0
#define BE_ASSISTANT 1
#define RETURN_TO_LOBBY 2

datum/preferences
	var/show_choices = 1

	//doohickeys for savefiles
	var/path
	var/default_slot = 1				//Holder so it doesn't default to slot 1, rather the last one used
	var/savefile_version = 0

	//non-preference stuff
	var/warns = 0
	var/muted = 0
	var/last_ip
	var/last_id

	//game-preferences
	var/lastchangelog = ""				//Saved changlog filesize to detect if there was a change
	var/ooccolor = "#010000"			//Whatever this is set to acts as 'reset' color and is thus unusable as an actual custom color
	var/be_special = 0					//Special role selection
	var/UI_style = "White"
	var/toggles = TOGGLES_DEFAULT
	var/UI_style_color = "#ffffff"
	var/UI_style_alpha = 255

	//character preferences
	var/real_name						//our character's name
	var/be_random_name = 0				//whether we are a random name every round
	var/gender = MALE					//gender of character (well duh)
	var/age = 30						//age of character
	var/spawnpoint = "Arrivals Shuttle" //where this character will spawn (0-2).
	var/b_type = "A+"					//blood type (not-chooseable)
	var/pony_tail_style = "Short Tail"	//pony_tail type
	var/r_tail = 0						//Face hair color
	var/g_tail = 0						//Face hair color
	var/b_tail = 0						//Face hair color
	var/cutie_mark = "Blank"			//Cutie mark type
	var/backbag = 2						//backpack type
	var/h_style = "Short Hair"			//Hair type
	var/r_hair = 0						//Hair color
	var/g_hair = 0						//Hair color
	var/b_hair = 0						//Hair color
	var/f_style = "Shaved"				//Face hair type
	var/r_facial = 0					//Face hair color
	var/g_facial = 0					//Face hair color
	var/b_facial = 0					//Face hair color
	var/s_tone = 0						//Skin tone
	var/r_skin = 200						//Skin color
	var/g_skin = 200						//Skin color
	var/b_skin = 200						//Skin color
	var/r_aura = 200						//Aura color
	var/g_aura = 200						//Aura color
	var/b_aura = 200						//Aura color
	var/r_eyes = 10						//Eye color
	var/g_eyes = 10						//Eye color
	var/b_eyes = 60						//Eye color
	var/species = "Earthpony"           //Species datum to use.
	var/species_preview                 //Used for the species selection window.
	var/language = "None"				//Secondary language
	var/list/gear						//Custom/fluff item loadout.
	var/total_SP = 0
	var/free_SP = 0
		//Some faction information.
	var/home_system = "Unset"           //System of birth.
	var/citizenship = "None"            //Current home system.
	var/faction = "None"                //Antag faction/general associated faction.
	var/religion = "None"               //Religious association.

		//Mob preview
	var/icon/preview_icon = null
	var/icon/preview_icon_front = null
	var/icon/preview_icon_side = null

		//Jobs, uses bitflags
	var/job_civilian_high = 0
	var/job_civilian_med = 0
	var/job_civilian_low = 0

	var/job_medsci_high = 0
	var/job_medsci_med = 0
	var/job_medsci_low = 0

	var/job_engsec_high = 0
	var/job_engsec_med = 0
	var/job_engsec_low = 0

	//Keeps track of preferrence for not getting any wanted jobs
	var/alternate_option = 0

	var/used_skillpoints = 0
	var/skill_specialization = null
	var/list/skills = list() // skills can range from 0 to 3

	// maps each organ to either null(intact), "cyborg" or "amputated"
	// will probably not be able to do this for head and torso ;)
	var/list/organ_data = list()
	var/list/player_alt_titles = new()		// the default name of a job like "Medical Doctor"

	var/list/flavor_texts = list()
	var/list/flavour_texts_robot = list()

	var/med_record = ""
	var/sec_record = ""
	var/gen_record = ""
	var/exploit_record = ""
	var/disabilities = 0

	var/nanotrasen_relation = "Neutral"

	var/uplinklocation = "PDA"

		// OOC Metadata:
	var/metadata = ""
	var/slot_name = ""

	var/brush_color
	var/colors5x5[5][5]//��� ������ � ���� ����������
	var/custom_cutiemark = 0
	var/icon/cutiemark_paint_west
	var/icon/cutiemark_paint_east
	var/list/spell_paths = list()

/datum/preferences/New(client/C)
	for(var/i1=1, i1<=5, i1++)	for(var/i2=1, i2<=5, i2++)
		colors5x5[i1][i2]="#00000000"


	b_type = pick(4;"O-", 36;"O+", 3;"A-", 28;"A+", 1;"B-", 20;"B+", 1;"AB-", 5;"AB+")
	if(istype(C) && !IsGuestKey(C.key))
		load_path(C.ckey)
		if(load_preferences() && load_character())
			return

	randomize_appearance_for()//��������� �������� ��� ������ ���������� ������
	real_name = random_name(gender,species)

	gear = list()
	update_custom_cutiemark()

/datum/preferences/proc/ZeroSkills(var/forced = 0)
	for(var/V in SKILLS) for(var/datum/skill/S in SKILLS[V])
		if(!skills.Find(S.ID) || forced)
			skills[S.ID] = SKILL_NONE

/datum/preferences/proc/CalculateSkillPoints()
	used_skillpoints = 0
	for(var/V in SKILLS) for(var/datum/skill/S in SKILLS[V])
		var/multiplier = 1
		switch(skills[S.ID])
			if(SKILL_NONE)
				used_skillpoints += 0 * multiplier
			if(SKILL_BASIC)
				used_skillpoints += 1 * multiplier
			if(SKILL_ADEPT)
				// secondary skills cost less
				if(S.secondary)
					used_skillpoints += 1 * multiplier
				else
					used_skillpoints += 3 * multiplier
			if(SKILL_EXPERT)
				// secondary skills cost less
				if(S.secondary)
					used_skillpoints += 3 * multiplier
				else
					used_skillpoints += 6 * multiplier

/datum/preferences/proc/GetSkillClass(points)
	return CalculateSkillClass(points, age)

/proc/CalculateSkillClass(points, age)
	if(points <= 0) return "Unconfigured"
	// skill classes describe how your character compares in total points
	points -= min(round((age - 20) / 2.5), 4) // every 2.5 years after 20, one extra skillpoint
	if(age > 30)
		points -= round((age - 30) / 5) // every 5 years after 30, one extra skillpoint
	switch(points)
		if(-1000 to 3)
			return "Terrifying"
		if(4 to 6)
			return "Below Average"
		if(7 to 10)
			return "Average"
		if(11 to 14)
			return "Above Average"
		if(15 to 18)
			return "Exceptional"
		if(19 to 24)
			return "Genius"
		if(24 to 1000)
			return "God"

/datum/preferences/proc/SetSkills(mob/user)
	if(SKILLS == null)
		setup_skills()

	if(skills.len == 0)
		ZeroSkills()


	var/HTML = "<body>"
	HTML += "<b>Select your Skills</b><br>"
	HTML += "Current skill level: <b>[GetSkillClass(used_skillpoints)]</b> ([used_skillpoints])<br>"
	HTML += "<a href=\"byond://?src=\ref[user];preference=skills;preconfigured=1;\">Use preconfigured skillset</a><br>"
	HTML += "<table>"
	for(var/V in SKILLS)
		HTML += "<tr><th colspan = 5><b>[V]</b>"
		HTML += "</th></tr>"
		for(var/datum/skill/S in SKILLS[V])
			var/level = skills[S.ID]
			HTML += "<tr style='text-align:left;'>"
			HTML += "<th><a href='byond://?src=\ref[user];preference=skills;skillinfo=\ref[S]'>[S.name]</a></th>"
			HTML += "<th><a href='byond://?src=\ref[user];preference=skills;setskill=\ref[S];newvalue=[SKILL_NONE]'><font color=[(level == SKILL_NONE) ? "red" : "black"]>\[Untrained\]</font></a></th>"
			// secondary skills don't have an amateur level
			if(S.secondary)
				HTML += "<th></th>"
			else
				HTML += "<th><a href='byond://?src=\ref[user];preference=skills;setskill=\ref[S];newvalue=[SKILL_BASIC]'><font color=[(level == SKILL_BASIC) ? "red" : "black"]>\[Amateur\]</font></a></th>"
			HTML += "<th><a href='byond://?src=\ref[user];preference=skills;setskill=\ref[S];newvalue=[SKILL_ADEPT]'><font color=[(level == SKILL_ADEPT) ? "red" : "black"]>\[Trained\]</font></a></th>"
			HTML += "<th><a href='byond://?src=\ref[user];preference=skills;setskill=\ref[S];newvalue=[SKILL_EXPERT]'><font color=[(level == SKILL_EXPERT) ? "red" : "black"]>\[Professional\]</font></a></th>"
			HTML += "</tr>"
	HTML += "</table>"
	HTML += "<a href=\"byond://?src=\ref[user];preference=skills;cancel=1;\">\[Done\]</a>"

	user << browse(null, "window=preferences")
	user << browse(HTML, "window=show_skills;size=600x800")
	return

/datum/preferences/proc/ShowChoices(mob/user)
	if(!show_choices)
		show_choices = 1
		return
	if(!user || !user.client)	return
	if(!pony_tail_style)	pony_tail_style = "Short Tail"
	update_preview_icon()
	user << browse_rsc(preview_icon_front, "previewicon.png")
	user << browse_rsc(preview_icon_side, "previewicon2.png")
	var/dat = "<html><body><center>"

	if(path)
		dat += "<center>"
		dat += "[local("Slot")] <b>[slot_name]</b> - "
		dat += "<a href=\"byond://?src=\ref[user];preference=open_load_dialog\">[local("Load slot")]</a> - "
		dat += "<a href=\"byond://?src=\ref[user];preference=save\">[local("Save slot")]</a> - "
		dat += "<a href=\"byond://?src=\ref[user];preference=reload\">[local("Reload slot")]</a>"
		dat += "</center>"

	else
		dat += local("Please create an account to save your preferences.")

	dat += "</center><hr><table><tr><td width='340px' height='320px'>"

	dat += "<b>[local("Name")]:</b> "
	dat += "<a href='?_src_=prefs;preference=name;task=input'><b>[real_name]</b></a><br>"
	dat += "(<a href='?_src_=prefs;preference=name;task=random'>[local("Random name")]</A>) "
	dat += "(<a href='?_src_=prefs;preference=name'>[local("Always random name")]: [be_random_name ? local("Yes") : local("No")]</a>)"
	dat += "<br>"

	dat += "<b>[local("Gender")]:</b> <a href='?_src_=prefs;preference=gender'><b>[gender == MALE ? local("Male") : local("Female")]</b></a><br>"
	dat += "<b>[local("Age")]:</b> <a href='?_src_=prefs;preference=age;task=input'>[age]</a><br>"
	dat += "<b>[local("Spawn Point")]</b>: <a href='byond://?src=\ref[user];preference=spawnpoint;task=input'>[spawnpoint]</a>"

	dat += "<br>"
	dat += "<b>[local("UI Style")]:</b> <a href='?_src_=prefs;preference=ui'><b>[UI_style]</b></a><br>"
	dat += "<b>[local("Custom UI")]</b>(recommended for White UI):<br>"
	dat += "-[local("Color")]: <b><table style='display:inline;' bgcolor='[UI_style_color]'><tr><td><a href='?_src_=prefs;preference=UIcolor'>__</a></td></tr></table></b> <br>"
	dat += "-[local("Transparency")]: <a href='?_src_=prefs;preference=UIalpha'><b>[UI_style_alpha]</b></a><br>"
	dat += "<b>[local("Play admin midis")]:</b> <a href='?_src_=prefs;preference=hear_midis'><b>[(toggles & SOUND_MIDI) ? local("Yes") : local("No")]</b></a><br>"
	dat += "<b>[local("Hear lobby music")]:</b> <a href='?_src_=prefs;preference=lobby_music'><b>[(toggles & SOUND_LOBBY) ? local("Yes") : local("No")]</b></a><br>"
	dat += "<b>[local("Ghost ears")]:</b> <a href='?_src_=prefs;preference=ghost_ears'><b>[(toggles & CHAT_GHOSTEARS) ? local("All Speech") : local("Nearest Creatures")]</b></a><br>"
	dat += "<b>[local("Ghost sight")]:</b> <a href='?_src_=prefs;preference=ghost_sight'><b>[(toggles & CHAT_GHOSTSIGHT) ? local("All Emotes") : local("Nearest Creatures")]</b></a><br>"
	dat += "<b>[local("Ghost radio")]:</b> <a href='?_src_=prefs;preference=ghost_radio'><b>[(toggles & CHAT_GHOSTRADIO) ? local("All Speech") : local("Nearest Speakers")]</b></a><br>"

	if(config.allow_Metadata)
		dat += "<b>OOC [local("Notes")]:</b> <a href='?_src_=prefs;preference=metadata;task=input'> [local("Edit")] </a><br>"

	dat += "<br><b>[local("Custom Loadout")]:</b> "
	var/total_cost = 0

	if(!islist(gear)) gear = list()

	if(gear && gear.len)
		dat += "<br>"
		for(var/i = 1; i <= gear.len; i++)
			var/datum/gear/G = gear_datums[gear[i]]
			if(G)
				total_cost += G.cost
				dat += "[gear[i]] ([G.cost] [local("points")]) <a href='byond://?src=\ref[user];preference=loadout;task=remove;gear=[i]'>\[[local("remove")]\]</a><br>"

		dat += "<b>[local("Used")]:</b> [total_cost] [local("points")]."

	if(total_cost < MAX_GEAR_COST)
		dat += " <a href='byond://?src=\ref[user];preference=loadout;task=input'>\[[local("add")]\]</a>"
		if(gear && gear.len)
			dat += " <a href='byond://?src=\ref[user];preference=loadout;task=clear'>\[[local("clear")]\]</a>"

	dat += "<br><br><b>[local("Occupation Choices")]</b><br>"
	dat += "\t<a href='?_src_=prefs;preference=job;task=menu'><b>[local("Set Preferences")]</b></a><br>"

	dat += "<br><table><tr><td><b>[local("Body")]</b> "
	dat += "(<a href='?_src_=prefs;preference=all;task=random'>&reg;</A>)"
	dat += "<br>"
	dat += "[local("Species")]: <a href='?src=\ref[user];preference=species;task=change'>[species]</a><br>"
	if(species == "Unicorn")
		dat += "<b><a href=\"byond://?src=\ref[user];preference=spelloptions;active=0\">[local("Set Spells")]</b></a><br>"
	dat += "[local("Secondary Language")]: <a href='byond://?src=\ref[user];preference=language;task=input'>[language]</a><br>"
	dat += "[local("Blood Type")]: <a href='byond://?src=\ref[user];preference=b_type;task=input'>[b_type]</a><br>"
	//dat += "Skin Tone: <a href='?_src_=prefs;preference=s_tone;task=input'>[-s_tone + 35]/220<br></a>"//���� �� �����
	//dat += "Skin pattern: <a href='byond://?src=\ref[user];preference=skin_style;task=input'>Adjust</a><br>"
	dat += "[local("Glasses")]: <a href='?_src_=prefs;preference=disabilities'><b>[disabilities == 0 ? local("Not necessary") : local("Necessary")]</b></a><br>"
	dat += "[local("Limbs")]: <a href='byond://?src=\ref[user];preference=limbs;task=input'>[local("Adjust")]</a><br>"
	dat += "[local("Internal Organs")]: <a href='byond://?src=\ref[user];preference=organs;task=input'>[local("Adjust")]</a><br>"

	//display limbs below
	var/ind = 0
	for(var/name in organ_data)
		//world << "[ind] \ [organ_data.len]"
		var/status = organ_data[name]
		var/organ_name = null
		switch(name)
			if("l_arm")
				organ_name = "left foreleg"
			if("r_arm")
				organ_name = "right foreleg"
			if("l_leg")
				organ_name = "left back leg"
			if("r_leg")
				organ_name = "right back leg"
			if("l_foot")
				organ_name = "left back hoof"
			if("r_foot")
				organ_name = "right back hoof"
			if("l_hand")
				organ_name = "left forehoof"
			if("r_hand")
				organ_name = "right forehoof"
			if("heart")
				organ_name = "heart"
			if("eyes")
				organ_name = "eyes"


		if(status == "cyborg")
			++ind
			if(ind > 1)
				dat += ", "
			dat += "\t[local("Mechanical [organ_name] prothesis")]"
		else if(status == "amputated")
			++ind
			if(ind > 1)
				dat += ", "
			dat += "\t[local("Amputated [organ_name]")]"
		else if(status == "mechanical")
			++ind
			if(ind > 1)
				dat += ", "
			dat += "\t[local("Mechanical [organ_name]")]"
		else if(status == "assisted")
			++ind
			if(ind > 1)
				dat += ", "
			switch(organ_name)
				if("heart")
					dat += "\t[local("Pacemaker-assisted [organ_name]")]"
				if("voicebox") //on adding voiceboxes for speaking alicorn/similar replacements
					dat += "\t[local("Surgically altered [organ_name]")]"
				if("eyes")
					dat += "\t[local("Retinal overlayed [organ_name]")]"
				else
					dat += "\t[local("Mechanically assisted [organ_name]")]"
	if(!ind)
		dat += "\[...\]<br><br>"
	else
		dat += "<br><br>"


	dat += "[local("CutieMark")]:<br>"
	if(custom_cutiemark)
		dat += "<a href='?_src_=prefs;cutie_paint=draw;mod=1'><b>[local("Draw Custom")]</b>"
	else
		dat += "<a href='?_src_=prefs;preference=cutie_mark;task=input'>[cutie_mark]"
	dat += "</a><br>(Custom: <a href='?_src_=prefs;cutie_paint=switch'>"
	dat += (custom_cutiemark) ? local("Yes") : local("No")
	dat += "</a>)<br><br>"


	dat += "[local("Backpack Type")]:<br><a href ='?_src_=prefs;preference=bag;task=input'><b>[backbaglist[backbag]]</b></a><br>"

	dat += "[local("Nanotrasen Relation")]:<br><a href ='?_src_=prefs;preference=nt_relation;task=input'><b>[nanotrasen_relation]</b></a><br>"

	dat += "<br><br><b>[local("Background Information")]</b><br>"
	dat += "<b>[local("Home system")]</b>: <a href='byond://?src=\ref[user];preference=home_system;task=input'>[home_system]</a><br/>"
	dat += "<b>[local("Citizenship")]</b>: <a href='byond://?src=\ref[user];preference=citizenship;task=input'>[citizenship]</a><br/>"
	dat += "<b>[local("Faction")]</b>: <a href='byond://?src=\ref[user];preference=faction;task=input'>[faction]</a><br/>"
	dat += "<b>[local("Religion")]</b>: <a href='byond://?src=\ref[user];preference=religion;task=input'>[religion]</a><br/>"

	dat += "</td><td><b>[local("Preview")]</b><br><img src=previewicon.png height=64 width=64><img src=previewicon2.png height=64 width=64></td></tr></table>"

	dat += "</td><td width='300px' height='300px'>"

	if(jobban_isbanned(user, "Records"))
		dat += "<b>[local("You are banned from using character records")].</b><br>"
	else
		dat += "<b><a href=\"byond://?src=\ref[user];preference=records;record=1\">[local("Character Records")]</a></b><br>"

	dat += "<b><a href=\"byond://?src=\ref[user];preference=antagoptions;active=0\">[local("Set Antag Options")]</b></a><br>"

	dat += "\t<a href=\"byond://?src=\ref[user];preference=skills\"><b>[local("Set Skills")]</b> (<i>[GetSkillClass(used_skillpoints)] [used_skillpoints > 0 ? "[used_skillpoints]" : "0"]</i>)</a><br>"

	dat += "<a href='byond://?src=\ref[user];preference=flavor_text;task=open'><b>[local("Set Flavor Text")]</b></a><br>"
	dat += "<a href='byond://?src=\ref[user];preference=flavour_text_robot;task=open'><b>[local("Set Robot Flavour Text")]</b></a><br>"

	dat += "<a href='byond://?src=\ref[user];preference=pAI'><b>[local("pAI Configuration")]</b></a><br>"
	dat += "<br>"

	dat += "<br><b>[local("Mane")]</b><br>"
	dat += "<font face='fixedsys' size='3' color='#[num2hex(r_hair, 2)][num2hex(g_hair, 2)][num2hex(b_hair, 2)]'><table style='display:inline;' bgcolor='#[num2hex(r_hair, 2)][num2hex(g_hair, 2)][num2hex(b_hair)]'><tr><td><a href='?_src_=prefs;preference=hair;task=input'>__</a></td></tr></table></font> "
	dat += "  [local("Style")]: <a href='?_src_=prefs;preference=h_style;task=input'>[h_style]</a><br>"

	dat += "<br><b>[local("Facial")]</b><br>"
	dat += "<font face='fixedsys' size='3' color='#[num2hex(r_facial, 2)][num2hex(g_facial, 2)][num2hex(b_facial, 2)]'><table  style='display:inline;' bgcolor='#[num2hex(r_facial, 2)][num2hex(g_facial, 2)][num2hex(b_facial)]'><tr><td><a href='?_src_=prefs;preference=facial;task=input'>__</a></td></tr></table></font> "
	dat += " [local("Style")]: <a href='?_src_=prefs;preference=f_style;task=input'>[f_style]</a><br>"

	dat += "<br><b>[local("Tail")]</b><br>"
	dat += "<font face='fixedsys' size='3' color='#[num2hex(r_tail, 2)][num2hex(g_tail, 2)][num2hex(b_tail, 2)]'><table  style='display:inline;' bgcolor='#[num2hex(r_tail, 2)][num2hex(g_tail, 2)][num2hex(b_tail)]'><tr><td><a href='?_src_=prefs;preference=pony_tail;task=input'>__</a></td></tr></table></font> "
	dat += " [local("Style")]: <a href='?_src_=prefs;preference=pony_tail_style;task=input'>[pony_tail_style]</a><br>"

	dat += "<br><b>[local("Eyes")]: </b>"
	dat += "<font face='fixedsys' size='3' color='#[num2hex(r_eyes, 2)][num2hex(g_eyes, 2)][num2hex(b_eyes, 2)]'><table  style='display:inline;' bgcolor='#[num2hex(r_eyes, 2)][num2hex(g_eyes, 2)][num2hex(b_eyes)]'><tr><td><a href='?_src_=prefs;preference=eyes;task=input'>__</a></td></tr></table></font> <br>"

	dat += "<br><b>[local("Body Color")]: </b>"
	dat += "<font face='fixedsys' size='3' color='#[num2hex(r_skin, 2)][num2hex(g_skin, 2)][num2hex(b_skin, 2)]'><table style='display:inline;' bgcolor='#[num2hex(r_skin, 2)][num2hex(g_skin, 2)][num2hex(b_skin)]'><tr><td><a href='?_src_=prefs;preference=skin;task=input'>__</a></td></tr></table></font> <br>"

	dat += "<br><b>[local("Magic Aura Color")]:</b> "
	dat += "<font face='fixedsys' size='3' color='#[num2hex(r_aura, 2)][num2hex(g_aura, 2)][num2hex(b_aura, 2)]'><table style='display:inline;' bgcolor='#[num2hex(r_aura, 2)][num2hex(g_aura, 2)][num2hex(b_aura)]'><tr><td><a href='?_src_=prefs;preference=aura;task=input'>__</a></td></tr></table></font> <br>"

	dat += "<br><br>"

	if(jobban_isbanned(user, "Syndicate"))
		dat += "<b>[local("You are banned from antagonist roles")].</b>"
		src.be_special = 0
	else
		var/n = 0
		for (var/i in special_roles)
			if(special_roles[i]) //if mode is available on the server
				if(jobban_isbanned(user, i) || (i == "positronic brain" && jobban_isbanned(user, "AI") && jobban_isbanned(user, "Cyborg")) || (i == "pAI candidate" && jobban_isbanned(user, "pAI")))
					dat += "<b>Be [i]:<b> <font color=red><b> \[BANNED]</b></font><br>"
				else
					dat += "<b>Be [i]:</b> <a href='?_src_=prefs;preference=be_special;num=[n]'><b>[src.be_special&(1<<n) ? local("Yes") : local("No")]</b></a><br>"
			n++
	dat += "</td></tr></table><hr><center>"

	if(!IsGuestKey(user.key))
		dat += "<a href='?_src_=prefs;preference=load'>[local("Undo")]</a> - "
		dat += "<a href='?_src_=prefs;preference=save'>[local("Save Setup")]</a> - "

	dat += "<a href='?_src_=prefs;preference=reset_all'>[local("Reset Setup")]</a>"
	dat += "</center></body></html>"

	user << browse(fix_html(dat), "window=preferences;size=650x736")

/datum/preferences/proc/SetChoices(mob/user, limit = 16, list/splitJobs = list("Chief Medical Officer"), width = 550, height = 660)
	if(!job_master)
		return

	//limit 	 - The amount of jobs allowed per column. Defaults to 17 to make it look nice.
	//splitJobs - Allows you split the table by job. You can make different tables for each department by including their heads. Defaults to CE to make it look nice.
	//width	 - Screen' width. Defaults to 550 to make it look nice.
	//height 	 - Screen's height. Defaults to 500 to make it look nice.


	var/HTML = "<body>"
	HTML += "<tt><center>"
	HTML += "<b>Choose occupation chances</b><br>Unavailable occupations are crossed out.<br><br>"
	HTML += "<center><a href='?_src_=prefs;preference=job;task=close'>\[Done\]</a></center><br>" // Easier to press up here.
	HTML += "<table width='100%' cellpadding='1' cellspacing='0'><tr><td width='20%'>" // Table within a table for alignment, also allows you to easily add more colomns.
	HTML += "<table width='100%' cellpadding='1' cellspacing='0'>"
	var/index = -1

	//The job before the current job. I only use this to get the previous jobs color when I'm filling in blank rows.
	var/datum/job/lastJob
	if (!job_master)		return
	for(var/datum/job/job in job_master.occupations)

		index += 1
		if((index >= limit) || (job.title in splitJobs))
			if((index < limit) && (lastJob != null))
				//If the cells were broken up by a job in the splitJob list then it will fill in the rest of the cells with
				//the last job's selection color. Creating a rather nice effect.
				for(var/i = 0, i < (limit - index), i += 1)
					HTML += "<tr bgcolor='[lastJob.selection_color]'><td width='60%' align='right'><a>&nbsp</a></td><td><a>&nbsp</a></td></tr>"
			HTML += "</table></td><td width='20%'><table width='100%' cellpadding='1' cellspacing='0'>"
			index = 0

		HTML += "<tr bgcolor='[job.selection_color]'><td width='60%' align='right'>"
		var/rank = job.title
		lastJob = job
		if(jobban_isbanned(user, rank))
			HTML += "<del>[rank]</del></td><td><b> \[BANNED]</b></td></tr>"
			continue
		if(!job.player_old_enough(user.client))
			var/available_in_days = job.available_in_days(user.client)
			HTML += "<del>[rank]</del></td><td> \[IN [(available_in_days)] DAYS]</td></tr>"
			continue
		if((job_civilian_low & ASSISTANT) && (rank != "Assistant"))
			HTML += "<font color=orange>[rank]</font></td><td></td></tr>"
			continue
		if((rank in command_positions) || (rank == "AI"))//Bold head jobs
			HTML += "<b>[rank]</b>"
		else
			HTML += "[rank]"

		HTML += "</td><td width='40%'>"

		HTML += "<a href='?_src_=prefs;preference=job;task=input;text=[rank]'>"

		if(rank == "Assistant")//Assistant is special
			if(job_civilian_low & ASSISTANT)
				HTML += " <font color=green>\[Yes]</font>"
			else
				HTML += " <font color=red>\[No]</font>"
			if(job.alt_titles) //Blatantly cloned from a few lines down.
				HTML += "</a></td></tr><tr bgcolor='[lastJob.selection_color]'><td width='60%' align='center'><a>&nbsp</a></td><td><a href=\"byond://?src=\ref[user];preference=job;task=alt_title;job=\ref[job]\">\[[GetPlayerAltTitle(job)]\]</a></td></tr>"
			HTML += "</a></td></tr>"
			continue

		if(GetJobDepartment(job, 1) & job.flag)
			HTML += " <font color=blue>\[High]</font>"
		else if(GetJobDepartment(job, 2) & job.flag)
			HTML += " <font color=green>\[Medium]</font>"
		else if(GetJobDepartment(job, 3) & job.flag)
			HTML += " <font color=orange>\[Low]</font>"
		else
			HTML += " <font color=red>\[NEVER]</font>"
		if(job.alt_titles)
			HTML += "</a></td></tr><tr bgcolor='[lastJob.selection_color]'><td width='60%' align='center'><a>&nbsp</a></td><td><a href=\"byond://?src=\ref[user];preference=job;task=alt_title;job=\ref[job]\">\[[GetPlayerAltTitle(job)]\]</a></td></tr>"
		HTML += "</a></td></tr>"

	HTML += "</td'></tr></table>"

	HTML += "</center></table>"

	switch(alternate_option)
		if(GET_RANDOM_JOB)
			HTML += "<center><br><u><a href='?_src_=prefs;preference=job;task=random'><font color=green>Get random job if preferences unavailable</font></a></u></center><br>"
		if(BE_ASSISTANT)
			HTML += "<center><br><u><a href='?_src_=prefs;preference=job;task=random'><font color=red>Be assistant if preference unavailable</font></a></u></center><br>"
		if(RETURN_TO_LOBBY)
			HTML += "<center><br><u><a href='?_src_=prefs;preference=job;task=random'><font color=purple>Return to lobby if preference unavailable</font></a></u></center><br>"

	HTML += "<center><a href='?_src_=prefs;preference=job;task=reset'>\[Reset\]</a></center>"
	HTML += "</tt>"

	user << browse(null, "window=preferences")
	user << browse(HTML, "window=mob_occupation;size=[width]x[height]")
	return

/datum/preferences/proc/SetDisabilities(mob/user)
	var/HTML = "<body>"
	HTML += "<tt><center>"
	HTML += "<b>Choose disabilities</b><br>"

	HTML += "Need Glasses? <a href=\"byond://?src=\ref[user];preferences=1;disabilities=0\">[disabilities & (1<<0) ? "Yes" : "No"]</a><br>"
	HTML += "Seizures? <a href=\"byond://?src=\ref[user];preferences=1;disabilities=1\">[disabilities & (1<<1) ? "Yes" : "No"]</a><br>"
	HTML += "Coughing? <a href=\"byond://?src=\ref[user];preferences=1;disabilities=2\">[disabilities & (1<<2) ? "Yes" : "No"]</a><br>"
	HTML += "Tourettes/Twitching? <a href=\"byond://?src=\ref[user];preferences=1;disabilities=3\">[disabilities & (1<<3) ? "Yes" : "No"]</a><br>"
	HTML += "Nervousness? <a href=\"byond://?src=\ref[user];preferences=1;disabilities=4\">[disabilities & (1<<4) ? "Yes" : "No"]</a><br>"
	HTML += "Deafness? <a href=\"byond://?src=\ref[user];preferences=1;disabilities=5\">[disabilities & (1<<5) ? "Yes" : "No"]</a><br>"

	HTML += "<br>"
	HTML += "<a href=\"byond://?src=\ref[user];preferences=1;disabilities=-2\">\[Done\]</a>"
	HTML += "</center></tt>"

	user << browse(null, "window=preferences")
	user << browse(HTML, "window=disabil;size=350x300")
	return

/datum/preferences/proc/SetRecords(mob/user)
	var/HTML = "<body>"
	HTML += "<tt><center>"
	HTML += "<b>Set Character Records</b><br>"

	HTML += "<a href=\"byond://?src=\ref[user];preference=records;task=med_record\">Medical Records</a><br>"

	HTML += TextPreview(med_record,40)

	HTML += "<br><br><a href=\"byond://?src=\ref[user];preference=records;task=gen_record\">Employment Records</a><br>"

	HTML += TextPreview(gen_record,40)

	HTML += "<br><br><a href=\"byond://?src=\ref[user];preference=records;task=sec_record\">Security Records</a><br>"

	HTML += TextPreview(sec_record,40)

	HTML += "<br>"
	HTML += "<a href=\"byond://?src=\ref[user];preference=records;records=-1\">\[Done\]</a>"
	HTML += "</center></tt>"

	user << browse(null, "window=preferences")
	user << browse(HTML, "window=records;size=350x300")
	return

/datum/preferences/proc/SetSpecies(mob/user)
	if(!species_preview)
		species_preview = species

	if(!(species_preview in all_species))
		species_preview = "Earthpony"

	var/datum/species/current_species = all_species[species_preview]

	var/dat = {"<html><head>
	<script>
		var dir=1;
		var icon;
	</script>

	<script>
		function update_preview_icon() {
			switch(dir) {
				case 1:
					icon.src='species_preview_[current_species.name]_w.png';
					dir = 2;
					break;
				case 2:
					icon.src='species_preview_[current_species.name]_n.png';
					dir = 3;
					break;
				case 3:
					icon.src='species_preview_[current_species.name]_e.png';
					dir = 4;
					break;
				default:
					icon.src='species_preview_[current_species.name]_s.png';
					dir = 1;
					break;
			}
		}
	</script>
	</head><body>"}



	dat += "<center><h2>[current_species.name]</h2></center><hr/>"
	dat += "<table><tr><td>"
	dat += "<table border=1>"

	var/list/check_list = list()//��� �������� ������������
	for(var/S in playable_species)
		if(S in check_list)	continue
		check_list += S
		if(S!=current_species.name)
			dat += "<tr><td><a href='?src=\ref[user];preference=species;task=change;select=[S]'>[S]</a></td></tr>"
		else
			dat += "<tr><td><a href='?src=\ref[user];preference=species;task=change;select=[S]'><b>[S]</b></a></td></tr>"
	dat += "</table></td>"
	dat += "<td width=50> </td>"

	dat += "<td><table padding='8px'>"
	dat += "<tr>"
	if(user.client.language!="ru")	dat += {"<td width = 400>[current_species.blurb]</td>"}
	else							dat += {"<td width = 400>[current_species.blurb_ru]</td>"}
	dat += "<td width = 200 align='center'>"
	if("preview" in icon_states(current_species.icobase))
		usr << browse_rsc(icon(current_species.icobase,"preview", NORTH), "species_preview_[current_species.name]_n.png")
		usr << browse_rsc(icon(current_species.icobase,"preview", WEST), "species_preview_[current_species.name]_w.png")
		usr << browse_rsc(icon(current_species.icobase,"preview", SOUTH), "species_preview_[current_species.name]_s.png")
		usr << browse_rsc(icon(current_species.icobase,"preview", EAST), "species_preview_[current_species.name]_e.png")
		dat += {"<img src='species_preview_[current_species.name]_s.png' id="icon_preview" width='64px' height='64px'><br><br>"}

	dat += "<b>Language:</b> [current_species.language]<br>"
	dat += "<small>"
	if(current_species.flags & CAN_JOIN)
		dat += "</br><b>Often present on pony stations.</b>"
	if(current_species.flags & IS_WHITELISTED)
		dat += "</br><b>Whitelist restricted.</b>"
	if(current_species.flags & NO_BLOOD)
		dat += "</br><b>Does not have blood.</b>"
	if(current_species.flags & NO_BREATHE)
		dat += "</br><b>Does not breathe.</b>"
	if(current_species.flags & NO_SCAN)
		dat += "</br><b>Does not have DNA.</b>"
	if(current_species.flags & NO_PAIN)
		dat += "</br><b>Does not feel pain.</b>"
	if(current_species.flags & NO_SLIP)
		dat += "</br><b>Has excellent traction.</b>"
	if(current_species.flags & NO_POISON)
		dat += "</br><b>Immune to most poisons.</b>"
	if(/datum/organ/external/r_wing in current_species.has_external_organ && /datum/organ/external/l_wing in current_species.has_external_organ)
		dat += "</br><b>Has a wings and can fly.</b>"
	if(current_species.flags & HAS_SKIN_COLOR)
		dat += "</br><b>Has a variety of skin colours.</b>"
	if(current_species.flags & HAS_EYE_COLOR)
		dat += "</br><b>Has a variety of eye colours.</b>"
	if(current_species.flags & IS_PLANT)
		dat += "</br><b>Has a plantlike physiology.</b>"
	if(current_species.flags & IS_SYNTHETIC)
		dat += "</br><b>Is machine-based.</b>"
	dat += "</small></td>"
	dat += "</tr>"
	dat += "</table></td></tr></table><center><hr/>"
	spell_paths = list()
	if(/datum/organ/external/horn in current_species.has_external_organ)
		total_SP = current_species.name == "Alicorn" ? 10 : 5
		free_SP = total_SP
		dat += "</br><b>Has a horn and can make magic \[[total_SP]\].</b>"


	//var/restricted = 0
	//if(config.usealienwhitelist) //If we're using the whitelist, make sure to check it!
	//	if(!(current_species.flags & CAN_JOIN))
	//		restricted = 2
	//	else if((current_species.flags & IS_WHITELISTED) && !is_alien_whitelisted(user,current_species))
	//		restricted = 1

	//if(restricted)
	//	if(restricted == 1)
	//		dat += "<font color='red'><b>You cannot play as this species.</br><small>If you wish to be whitelisted, you can make an application post on <a href='?src=\ref[user];preference=open_whitelist_forum'>the forums</a>.</small></b></font></br>"
	//	else if(restricted == 2)
	//		dat += "<font color='red'><b>You cannot play as this species.</br><small>This species is not available for play as a station race..</small></b></font></br>"
	//if(!restricted || check_rights(R_ADMIN, 0))

	dat += "\[<a href='?src=\ref[user];preference=species;task=input;newspecies=[species_preview]'>select</a>\]"
	dat += "</center>"
	dat += {"
<script>
	icon = document.getElementById("icon_preview");
	setInterval(update_preview_icon, 1200);
</script>
	"}
	dat += "</body></html>"

	user << browse(null, "window=preferences")
	//user << browse(dat, "window=preferences;size=700x400")
	user << browse(dat, "window=species;size=700x400")

/datum/preferences/proc/SetAntagoptions(mob/user)
	if(uplinklocation == "" || !uplinklocation)
		uplinklocation = "PDA"
	var/HTML = "<body>"
	HTML += "<tt><center>"
	HTML += "<b>Antagonist Options</b> <hr />"
	HTML += "<br>"
	HTML +="Uplink Type : <b><a href='?src=\ref[user];preference=antagoptions;antagtask=uplinktype;active=1'>[uplinklocation]</a></b>"
	HTML +="<br>"
	HTML +="Exploitable information about you : "
	HTML += "<br>"
	if(jobban_isbanned(user, "Records"))
		HTML += "<b>You are banned from using character records.</b><br>"
	else
		HTML +="<b><a href=\"byond://?src=\ref[user];preference=records;task=exploitable_record\">[TextPreview(exploit_record,40)]</a></b>"


	user << browse(null, "window=preferences")
	user << browse(HTML, "window=antagoptions")
	return

/datum/preferences/proc/SetSpelloptions(mob/user)
	var/HTML = "<body>"
	HTML += "<tt><center>"
	HTML += "<b>Spell Options</b> <hr /><br>"
	free_SP = total_SP
	HTML += "<br><b>Spells:</b><br><table>"

	for(var/i = 1; i <= spell_paths.len; i++)
		var/spell_type = spell_paths[i]
		var/obj/effect/proc_holder/spell/targeted/civilian/G = new spell_type()
		free_SP -= G.spell_level
		HTML += "<tr><td>[i]. </td>"
		HTML += "<td> [G.name] </td>"
		HTML += "<td>  [G.spell_level] SP </td>"
		//HTML += "<td bgcolor=[G.color] width=30> [G.color] </td>"
		HTML += "<td> <a href='?src=\ref[user];preference=spelloptions;spelltask=removespell;spellname=[spell_type]'>Remove</a></td></tr>"
	HTML += "</table>"

	if(free_SP > 0)
		HTML +="<br><a href='?src=\ref[user];preference=spelloptions;spelltask=addspell'>Add Spell</a>"
	HTML +="<br>"
	HTML +="<br>"
	HTML +="Free Spell Points: [free_SP]/[total_SP]<br>"
	HTML +="<br><br>"
	HTML +="<hr />"
	HTML +="<a href='?src=\ref[user];preference=spelloptions;spelltask=done'>\[Done\]</a>"
	HTML += "</center></tt>"

	user << browse(null, "window=preferences")
	user << browse(HTML, "window=spelloptions;size=300x250")

	return

/datum/preferences/proc/SetFlavorText(mob/user)
	var/HTML = "<body>"
	HTML += "<tt><center>"
	HTML += "<b>Set Flavour Text</b> <hr />"
	HTML += "<br></center>"
	HTML += "<a href='byond://?src=\ref[user];preference=flavor_text;task=general'>General:</a> "
	HTML += TextPreview(flavor_texts["general"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[user];preference=flavor_text;task=head'>Head:</a> "
	HTML += TextPreview(flavor_texts["head"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[user];preference=flavor_text;task=face'>Face:</a> "
	HTML += TextPreview(flavor_texts["face"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[user];preference=flavor_text;task=eyes'>Eyes:</a> "
	HTML += TextPreview(flavor_texts["eyes"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[user];preference=flavor_text;task=torso'>Body:</a> "
	HTML += TextPreview(flavor_texts["torso"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[user];preference=flavor_text;task=arms'>Arms:</a> "
	HTML += TextPreview(flavor_texts["arms"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[user];preference=flavor_text;task=hands'>Hands:</a> "
	HTML += TextPreview(flavor_texts["hands"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[user];preference=flavor_text;task=legs'>Legs:</a> "
	HTML += TextPreview(flavor_texts["legs"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[user];preference=flavor_text;task=feet'>Feet:</a> "
	HTML += TextPreview(flavor_texts["feet"])
	HTML += "<br>"
	HTML += "<hr />"
	HTML +="<a href='?src=\ref[user];preference=flavor_text;task=done'>\[Done\]</a>"
	HTML += "<tt>"
	user << browse(null, "window=preferences")
	user << browse(HTML, "window=flavor_text;size=430x300")
	return

/datum/preferences/proc/SetFlavourTextRobot(mob/user)
	var/HTML = "<body>"
	HTML += "<tt><center>"
	HTML += "<b>Set Robot Flavour Text</b> <hr />"
	HTML += "<br></center>"
	HTML += "<a href ='byond://?src=\ref[user];preference=flavour_text_robot;task=Default'>Default:</a> "
	HTML += TextPreview(flavour_texts_robot["Default"])
	HTML += "<hr />"
	for(var/module in robot_module_types)
		HTML += "<a href='byond://?src=\ref[user];preference=flavour_text_robot;task=[module]'>[module]:</a> "
		HTML += TextPreview(flavour_texts_robot[module])
		HTML += "<br>"
	HTML += "<hr />"
	HTML +="<a href='?src=\ref[user];preference=flavour_text_robot;task=done'>\[Done\]</a>"
	HTML += "<tt>"
	user << browse(null, "window=preferences")
	user << browse(HTML, "window=flavour_text_robot;size=430x300")
	return

/datum/preferences/proc/GetPlayerAltTitle(datum/job/job)
	return player_alt_titles.Find(job.title) > 0 \
		? player_alt_titles[job.title] \
		: job.title

/datum/preferences/proc/SetPlayerAltTitle(datum/job/job, new_title)
	// remove existing entry
	if(player_alt_titles.Find(job.title))
		player_alt_titles -= job.title
	// add one if it's not default
	if(job.title != new_title)
		player_alt_titles[job.title] = new_title

/datum/preferences/proc/SetJob(mob/user, role)
	var/datum/job/job = job_master.GetJob(role)
	if(!job)
		user << browse(null, "window=mob_occupation")
		ShowChoices(user)
		return

	if(role == "Assistant")
		if(job_civilian_low & job.flag)
			job_civilian_low &= ~job.flag
		else
			job_civilian_low |= job.flag
		SetChoices(user)
		return 1

	if(GetJobDepartment(job, 1) & job.flag)
		SetJobDepartment(job, 1)
	else if(GetJobDepartment(job, 2) & job.flag)
		SetJobDepartment(job, 2)
	else if(GetJobDepartment(job, 3) & job.flag)
		SetJobDepartment(job, 3)
	else//job = Never
		SetJobDepartment(job, 4)

	SetChoices(user)
	return 1

/datum/preferences/proc/ResetJobs()
	job_civilian_high = 0
	job_civilian_med = 0
	job_civilian_low = 0

	job_medsci_high = 0
	job_medsci_med = 0
	job_medsci_low = 0

	job_engsec_high = 0
	job_engsec_med = 0
	job_engsec_low = 0


/datum/preferences/proc/GetJobDepartment(var/datum/job/job, var/level)
	if(!job || !level)	return 0
	switch(job.department_flag)
		if(CIVILIAN)
			switch(level)
				if(1)
					return job_civilian_high
				if(2)
					return job_civilian_med
				if(3)
					return job_civilian_low
		if(MEDSCI)
			switch(level)
				if(1)
					return job_medsci_high
				if(2)
					return job_medsci_med
				if(3)
					return job_medsci_low
		if(ENGSEC)
			switch(level)
				if(1)
					return job_engsec_high
				if(2)
					return job_engsec_med
				if(3)
					return job_engsec_low
	return 0

/datum/preferences/proc/SetJobDepartment(var/datum/job/job, var/level)
	if(!job || !level)	return 0
	switch(level)
		if(1)//Only one of these should ever be active at once so clear them all here
			job_civilian_high = 0
			job_medsci_high = 0
			job_engsec_high = 0
			return 1
		if(2)//Set current highs to med, then reset them
			job_civilian_med |= job_civilian_high
			job_medsci_med |= job_medsci_high
			job_engsec_med |= job_engsec_high
			job_civilian_high = 0
			job_medsci_high = 0
			job_engsec_high = 0

	switch(job.department_flag)
		if(CIVILIAN)
			switch(level)
				if(2)
					job_civilian_high = job.flag
					job_civilian_med &= ~job.flag
				if(3)
					job_civilian_med |= job.flag
					job_civilian_low &= ~job.flag
				else
					job_civilian_low |= job.flag
		if(MEDSCI)
			switch(level)
				if(2)
					job_medsci_high = job.flag
					job_medsci_med &= ~job.flag
				if(3)
					job_medsci_med |= job.flag
					job_medsci_low &= ~job.flag
				else
					job_medsci_low |= job.flag
		if(ENGSEC)
			switch(level)
				if(2)
					job_engsec_high = job.flag
					job_engsec_med &= ~job.flag
				if(3)
					job_engsec_med |= job.flag
					job_engsec_low &= ~job.flag
				else
					job_engsec_low |= job.flag
	return 1


















///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------------------------------------------//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////












/datum/preferences/proc/update_custom_cutiemark(mob/user)
	del(cutiemark_paint_east)
	del(cutiemark_paint_west)
	cutiemark_paint_west = new/icon('icons/mob/cutiemarks.dmi', "blank")
	cutiemark_paint_east = new/icon('icons/mob/cutiemarks.dmi', "blank")
	for(var/ix=1, ix<=5, ix++)	for(var/iy=1, iy<=5, iy++)
		cutiemark_paint_east.DrawBox(colors5x5[ix][iy], 11+ix, 9+iy)
		cutiemark_paint_west.DrawBox(colors5x5[ix][iy], 16+6-ix, 9+iy)

	if(user)
		user << browse_rsc(new/icon('icons/paint.dmi',"brush"),"brush.jpg")
		user << browse_rsc(new/icon('icons/paint.dmi',"eraser"),"eraser.jpg")
		user << browse_rsc(cutiemark_paint_east,"cutiemark_paint.png")
		user << browse_rsc(cutiemark_paint_west,"cutiemark_paint2.png")


/datum/preferences/proc/process_link(mob/user, list/href_list)
	if(!user)	return

	if(!istype(user, /mob/new_player))	return

	switch(href_list["cutie_paint"])
		if("1")
			brush_color = input(usr, "Choose your brush colour:", "Character Preference", brush_color) as color|null
			CustomCutiemarkPaint(user)
			return
		if("pixel")
			var/ix = text2num(href_list["x"])
			var/iy = text2num(href_list["y"])
			if(text2num(href_list["mod"])==1)		colors5x5[ix][iy] = brush_color
			else									colors5x5[ix][iy] = "#00000000"
			CustomCutiemarkPaint(user, text2num(href_list["mod"]))
			return
		if("3")
			user << browse(null,  "window=cutie_paint")
		if("switch")
			update_custom_cutiemark()
			custom_cutiemark = !custom_cutiemark
		if("draw")
			world << href_list["mod"]
			CustomCutiemarkPaint(user, text2num(href_list["mod"]))
			return


	if(href_list["preference"] == "open_whitelist_forum")
		if(config.forumurl)
			user << link(config.forumurl)
		else
			user << "<span class='danger'>The forum URL is not set in the server configuration.</span>"
			return

	if(href_list["preference"] == "job")
		switch(href_list["task"])
			if("close")
				user << browse(null, "window=mob_occupation")
				ShowChoices(user)
			if("reset")
				ResetJobs()
				SetChoices(user)
			if("random")
				if(alternate_option == GET_RANDOM_JOB || alternate_option == BE_ASSISTANT)
					alternate_option += 1
				else if(alternate_option == RETURN_TO_LOBBY)
					alternate_option = 0
				else
					return 0
				SetChoices(user)
			if ("alt_title")
				var/datum/job/job = locate(href_list["job"])
				if (job)
					var/choices = list(job.title) + job.alt_titles
					var/choice = input("Pick a title for [job.title].", "Character Generation", GetPlayerAltTitle(job)) as anything in choices | null
					if(choice)
						SetPlayerAltTitle(job, choice)
						SetChoices(user)
			if("input")
				SetJob(user, href_list["text"])
			else
				SetChoices(user)
		return 1
	else if(href_list["preference"] == "skills")
		if(href_list["cancel"])
			user << browse(null, "window=show_skills")
			ShowChoices(user)
		else if(href_list["skillinfo"])
			var/datum/skill/S = locate(href_list["skillinfo"])
			var/HTML = "<b>[S.name]</b><br>[S.desc]"
			user << browse(HTML, "window=\ref[user]skillinfo")
		else if(href_list["setskill"])
			var/datum/skill/S = locate(href_list["setskill"])
			var/value = text2num(href_list["newvalue"])
			skills[S.ID] = value
			CalculateSkillPoints()
			SetSkills(user)
		else if(href_list["preconfigured"])
			var/selected = input(user, "Select a skillset", "Skillset") as null|anything in SKILL_PRE
			if(!selected) return

			ZeroSkills(1)
			for(var/V in SKILL_PRE[selected])
				if(V == "field")
					skill_specialization = SKILL_PRE[selected]["field"]
					continue
				skills[V] = SKILL_PRE[selected][V]
			CalculateSkillPoints()

			SetSkills(user)
		else if(href_list["setspecialization"])
			skill_specialization = href_list["setspecialization"]
			CalculateSkillPoints()
			SetSkills(user)
		else
			SetSkills(user)
		return 1

	else if (href_list["preference"] == "loadout")

		if(href_list["task"] == "input")

			var/list/valid_gear_choices = list()

			for(var/gear_name in gear_datums)
				var/datum/gear/G = gear_datums[gear_name]
				if(G.whitelisted && !is_alien_whitelisted(user, G.whitelisted))
					continue
				valid_gear_choices += gear_name

			var/choice = input(user, "Select gear to add: ") as null|anything in valid_gear_choices

			if(choice && gear_datums[choice])

				var/total_cost = 0

				if(isnull(gear) || !islist(gear)) gear = list()

				if(gear && gear.len)
					for(var/gear_name in gear)
						if(gear_datums[gear_name])
							var/datum/gear/G = gear_datums[gear_name]
							total_cost += G.cost

				var/datum/gear/C = gear_datums[choice]
				total_cost += C.cost
				if(C && total_cost <= MAX_GEAR_COST)
					gear += choice
					user << "<span class='notice'>Added \the '[choice]' for [C.cost] points ([MAX_GEAR_COST - total_cost] points remaining).</span>"
				else
					user << "<span class='warning'>Adding \the '[choice]' will exceed the maximum loadout cost of [MAX_GEAR_COST] points.</span>"

		else if(href_list["task"] == "remove")
			var/i_remove = text2num(href_list["gear"])
			if(i_remove < 1 || i_remove > gear.len) return
			gear.Cut(i_remove, i_remove + 1)

		else if(href_list["task"] == "clear")
			gear.Cut()

	else if(href_list["preference"] == "flavor_text")
		switch(href_list["task"])
			if("open")
				SetFlavorText(user)
				return
			if("done")
				user << browse(null, "window=flavor_text")
				ShowChoices(user)
				return
			if("general")
				var/msg = input(usr,"Give a general description of your character. This will be shown regardless of clothing, and may include OOC notes and preferences.","Flavor Text",html_decode(flavor_texts[href_list["task"]])) as message
				if(msg != null)
					msg = copytext(msg, 1, MAX_MESSAGE_LEN)
					msg = html_encode(msg)
				flavor_texts[href_list["task"]] = msg
			else
				var/msg = input(usr,"Set the flavor text for your [href_list["task"]].","Flavor Text",html_decode(flavor_texts[href_list["task"]])) as message
				if(msg != null)
					msg = copytext(msg, 1, MAX_MESSAGE_LEN)
					msg = html_encode(msg)
				flavor_texts[href_list["task"]] = msg
		SetFlavorText(user)
		return

	else if(href_list["preference"] == "flavour_text_robot")
		switch(href_list["task"])
			if("open")
				SetFlavourTextRobot(user)
				return
			if("done")
				user << browse(null, "window=flavour_text_robot")
				ShowChoices(user)
				return
			if("Default")
				var/msg = input(usr,"Set the default flavour text for your robot. It will be used for any module without individual setting.","Flavour Text",html_decode(flavour_texts_robot["Default"])) as message
				if(msg != null)
					msg = copytext(msg, 1, MAX_MESSAGE_LEN)
					msg = html_encode(msg)
				flavour_texts_robot[href_list["task"]] = msg
			else
				var/msg = input(usr,"Set the flavour text for your robot with [href_list["task"]] module. If you leave this empty, default flavour text will be used for this module.","Flavour Text",html_decode(flavour_texts_robot[href_list["task"]])) as message
				if(msg != null)
					msg = copytext(msg, 1, MAX_MESSAGE_LEN)
					msg = html_encode(msg)
				flavour_texts_robot[href_list["task"]] = msg
		SetFlavourTextRobot(user)
		return

	else if(href_list["preference"] == "pAI")
		paiController.recruitWindow(user, 0)
		return 1

	else if(href_list["preference"] == "records")
		if(text2num(href_list["record"]) >= 1)
			SetRecords(user)
			return
		else
			user << browse(null, "window=records")
		if(href_list["task"] == "med_record")
			var/medmsg = input(usr,"Set your medical notes here.","Medical Records",html_decode(med_record)) as message

			if(medmsg != null)
				medmsg = copytext(medmsg, 1, MAX_PAPER_MESSAGE_LEN)
				medmsg = html_encode(medmsg)

				med_record = medmsg
				SetRecords(user)

		if(href_list["task"] == "sec_record")
			var/secmsg = input(usr,"Set your security notes here.","Security Records",html_decode(sec_record)) as message

			if(secmsg != null)
				secmsg = copytext(secmsg, 1, MAX_PAPER_MESSAGE_LEN)
				secmsg = html_encode(secmsg)

				sec_record = secmsg
				SetRecords(user)
		if(href_list["task"] == "gen_record")
			var/genmsg = input(usr,"Set your employment notes here.","Employment Records",html_decode(gen_record)) as message

			if(genmsg != null)
				genmsg = copytext(genmsg, 1, MAX_PAPER_MESSAGE_LEN)
				genmsg = html_encode(genmsg)

				gen_record = genmsg
				SetRecords(user)

		if(href_list["task"] == "exploitable_record")
			var/exploitmsg = input(usr,"Set exploitable information about you here.","Exploitable Information",html_decode(exploit_record)) as message

			if(exploitmsg != null)
				exploitmsg = copytext(exploitmsg, 1, MAX_PAPER_MESSAGE_LEN)
				exploitmsg = html_encode(exploitmsg)

				exploit_record = exploitmsg
				SetAntagoptions(user)

	else if (href_list["preference"] == "antagoptions")
		if(text2num(href_list["active"]) == 0)
			SetAntagoptions(user)
			return
		if (href_list["antagtask"] == "uplinktype")
			if (uplinklocation == "PDA")
				uplinklocation = "Headset"
			else if(uplinklocation == "Headset")
				uplinklocation = "None"
			else
				uplinklocation = "PDA"
			SetAntagoptions(user)
		if (href_list["antagtask"] == "done")
			user << browse(null, "window=antagoptions")
			ShowChoices(user)
		return 1

	else if (href_list["preference"] == "spelloptions")
		if(text2num(href_list["active"]) == 0)
			SetSpelloptions(user)
			return
		if (href_list["spelltask"] == "addspell")
			var/list/valid_spell_choices = list()
			if(isnull(spell_paths) || !islist(spell_paths)) spell_paths = list()

			for(var/spell_name in typesof(/obj/effect/proc_holder/spell/targeted/civilian)-/obj/effect/proc_holder/spell/targeted/civilian)
				var/obj/effect/proc_holder/spell/targeted/civilian/S = new spell_name
				if(!spell_paths.Find(spell_name) && S.spell_level <= free_SP)	valid_spell_choices += S
			if(valid_spell_choices.len > 0)
				var/obj/effect/proc_holder/spell/targeted/civilian/choice = input(user, "Select spell to add: ") as null|anything in valid_spell_choices
				spell_paths += choice.type
			SetSpelloptions(user)
		if (href_list["spelltask"] == "removespell")
			spell_paths.Remove(text2path(href_list["spellname"]))
			SetSpelloptions(user)
		if (href_list["spelltask"] == "done")
			user << browse(null, "window=spelloptions")
			ShowChoices(user)
		return 1

	else if (href_list["preference"] == "loadout")

		if(href_list["task"] == "input")

			var/list/valid_gear_choices = list()

			for(var/gear_name in gear_datums)
				var/datum/gear/G = gear_datums[gear_name]
				if(G.whitelisted && !is_alien_whitelisted(user, G.whitelisted))
					continue
				valid_gear_choices += gear_name

			var/choice = input(user, "Select gear to add: ") as null|anything in valid_gear_choices

			if(choice && gear_datums[choice])

				var/total_cost = 0

				if(isnull(gear) || !islist(gear)) gear = list()

				if(gear && gear.len)
					for(var/gear_name in gear)
						if(gear_datums[gear_name])
							var/datum/gear/G = gear_datums[gear_name]
							total_cost += G.cost

				var/datum/gear/C = gear_datums[choice]
				total_cost += C.cost
				if(C && total_cost <= MAX_GEAR_COST)
					gear += choice
					user << "\blue Added [choice] for [C.cost] points ([MAX_GEAR_COST - total_cost] points remaining)."
				else
					user << "\red That item will exceed the maximum loadout cost of [MAX_GEAR_COST] points."

		else if(href_list["task"] == "remove")

			if(isnull(gear) || !islist(gear))
				gear = list()
			if(!gear.len)
				return

			var/choice = input(user, "Select gear to remove: ") as null|anything in gear
			if(!choice)
				return

			for(var/gear_name in gear)
				if(gear_name == choice)
					gear -= gear_name
					break

	switch(href_list["task"])
		if("change")
			if(href_list["preference"] == "species")
				// Actual whitelist checks are handled elsewhere, this is just for accessing the preview window.
				if(href_list["select"])
					species_preview = href_list["select"]

				show_choices = 0
				SetSpecies(user)


		if("random")
			switch(href_list["preference"])
				if("name")
					real_name = random_name(gender,species)
				if("age")
					age = rand(AGE_MIN, AGE_MAX)
				if("hair")
					randomize_hair_color("hair")
				if("h_style")
					h_style = random_style(gender, species)
				if("facial")
					randomize_hair_color("facial")
				if("f_style")
					f_style = random_style(gender, species, facial_hair_styles_list)
				if("pony_tail_style")
					pony_tail_style = random_style(gender, species, pony_tail_styles_list)
				if("pony_tail_color")
					randomize_hair_color("tail")
				if("aura")
					randomize_aura_color()
					//ShowChoices(user)
				if("cutie_mark")
					cutie_mark = random_cutiemark()
					//ShowChoices(user)
				if("eyes")
					randomize_eyes_color()
				if("s_tone")
					s_tone = random_skin_tone()
				if("s_color")
					randomize_skin_color()
				if("bag")
					backbag = rand(1,4)
				/*if("skin_style")
					h_style = random_skin_style(gender)*/
				if("all")
					randomize_appearance_for()	//no params needed
		if("input")
			switch(href_list["preference"])
				if("name")
					var/raw_name = input(user, "Choose your character's name:", "Character Preference")  as text|null
					if (!isnull(raw_name)) // Check to ensure that the user entered text (rather than cancel.)
						var/new_name = reject_bad_name(raw_name)
						if(new_name)
							real_name = new_name
						else
							user << "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</font>"

				if("age")
					var/new_age = input(user, "Choose your character's age:\n([AGE_MIN]-[AGE_MAX])", "Character Preference") as num|null
					if(new_age)
						age = max(min( round(text2num(new_age)), AGE_MAX),AGE_MIN)

				if("species")
					user << browse(null, "window=species")
					var/prev_species = species
					species = href_list["newspecies"]
					if(prev_species != species)
						randomize_appearance_for()


				if("language")
					var/languages_available
					var/list/new_languages = list("None")
					var/datum/species/S = all_species[species]

					if(config.usealienwhitelist)
						for(var/L in all_languages)
							var/datum/language/lang = all_languages[L]
							if((!(lang.flags & RESTRICTED)) && (is_alien_whitelisted(user, L)||(!( lang.flags & WHITELISTED ))||(S && (L in S.secondary_langs))))
								new_languages += lang

								languages_available = 1

						if(!(languages_available))
							alert(user, "There are not currently any available secondary languages.")
					else
						for(var/L in all_languages)
							var/datum/language/lang = all_languages[L]
							if(!(lang.flags & RESTRICTED))
								new_languages += lang.name

					language = input("Please select a secondary language", "Character Generation", null) in new_languages

				if("metadata")
					var/new_metadata = input(user, "Enter any information you'd like others to see, such as Roleplay-preferences:", "Game Preference" , metadata)  as message|null
					if(new_metadata)
						metadata = sanitize(copytext(new_metadata,1,MAX_MESSAGE_LEN))

				if("b_type")
					var/new_b_type = input(user, "Choose your character's blood-type:", "Character Preference") as null|anything in list( "A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-" )
					if(new_b_type)
						b_type = new_b_type

				if("hair")
					if(species == "Earthpony" || species == "Unicorn" || species == "Pegasus" || species == "Alicorn")
						var/new_hair = input(user, "Choose your character's hair colour:", "Character Preference", rgb(r_hair, g_hair, b_hair)) as color|null
						if(new_hair)
							r_hair = hex2num(copytext(new_hair, 2, 4))
							g_hair = hex2num(copytext(new_hair, 4, 6))
							b_hair = hex2num(copytext(new_hair, 6, 8))

				if("aura")
					var/new_aura = input(user, "Choose your character's hair colour:", "Character Preference", rgb(r_aura, g_aura, b_aura)) as color|null
					if(new_aura)
						r_aura = hex2num(copytext(new_aura, 2, 4))
						g_aura = hex2num(copytext(new_aura, 4, 6))
						b_aura = hex2num(copytext(new_aura, 6, 8))

				if("h_style")
					var/list/valid_hairstyles = list()
					for(var/hairstyle in hair_styles_list)
						var/datum/sprite_accessory/S = hair_styles_list[hairstyle]
						if(gender == MALE && S.gender == FEMALE)
							continue
						if(gender == FEMALE && S.gender == MALE)
							continue
						if( !(species in S.species_allowed))
							continue

						valid_hairstyles[hairstyle] = hair_styles_list[hairstyle]

					var/new_h_style = input(user, "Choose your character's hair style:", "Character Preference")  as null|anything in valid_hairstyles
					if(new_h_style)
						h_style = new_h_style

				if("facial")
					var/new_facial = input(user, "Choose your character's facial-hair colour:", "Character Preference", rgb(r_facial, g_facial, b_facial)) as color|null
					if(new_facial)
						r_facial = hex2num(copytext(new_facial, 2, 4))
						g_facial = hex2num(copytext(new_facial, 4, 6))
						b_facial = hex2num(copytext(new_facial, 6, 8))

				if("f_style")
					var/list/valid_facialhairstyles = list()
					for(var/facialhairstyle in facial_hair_styles_list)
						var/datum/sprite_accessory/S = facial_hair_styles_list[facialhairstyle]
						if(gender == MALE && S.gender == FEMALE)
							continue
						if(gender == FEMALE && S.gender == MALE)
							continue
						if( !(species in S.species_allowed))
							continue

						valid_facialhairstyles[facialhairstyle] = facial_hair_styles_list[facialhairstyle]

					var/new_f_style = input(user, "Choose your character's facial-hair style:", "Character Preference")  as null|anything in valid_facialhairstyles
					if(new_f_style)
						f_style = new_f_style

				if("pony_tail_style")
					var/list/valid_pony_tailstyles = list()
					for(var/pony_tailstyle in pony_tail_styles_list)
						var/datum/sprite_accessory/S = pony_tail_styles_list[pony_tailstyle]
						if(gender == MALE && S.gender == FEMALE)
							continue
						if(gender == FEMALE && S.gender == MALE)
							continue
						if( !(species in S.species_allowed))
							continue

						valid_pony_tailstyles[pony_tailstyle] = pony_tail_styles_list[pony_tailstyle]

					var/new_pt_style = input(user, "Choose your character's tail style:", "Character Preference")  as null|anything in valid_pony_tailstyles
					if(new_pt_style)
						pony_tail_style = new_pt_style
					ShowChoices(user)

				if("pony_tail")
					var/new_tail = input(user, "Choose your character's tail colour:", "Character Preference", rgb(r_tail, g_tail, b_tail)) as color|null
					if(new_tail)
						r_tail = hex2num(copytext(new_tail, 2, 4))
						g_tail = hex2num(copytext(new_tail, 4, 6))
						b_tail = hex2num(copytext(new_tail, 6, 8))

				if("cutie_mark")
					var/new_cutie_mark = input(user, "Choose your character's cutie mark:", "Character Preference") as null|anything in cutiemarks_list
					if (new_cutie_mark)
						cutie_mark = new_cutie_mark
					ShowChoices(user)

				if("eyes")
					var/new_eyes = input(user, "Choose your character's eye colour:", "Character Preference", rgb(r_eyes, g_eyes, b_eyes)) as color|null
					if(new_eyes)
						r_eyes = hex2num(copytext(new_eyes, 2, 4))
						g_eyes = hex2num(copytext(new_eyes, 4, 6))
						b_eyes = hex2num(copytext(new_eyes, 6, 8))

				if("s_tone")
					if(species != "Earthpony")
						return
					var/new_s_tone = input(user, "Choose your character's skin-tone:\n(Light 1 - 220 Dark)", "Character Preference")  as num|null
					if(new_s_tone)
						s_tone = 35 - max(min( round(new_s_tone), 220),1)

				if("skin")
					//if(species == "Unicorn" || species == "Pegasus" || species == "Alicorn")
					var/new_skin = input(user, "Choose your character's skin colour: ", "Character Preference", rgb(r_skin, g_skin, b_skin)) as color|null
					if(new_skin)
						r_skin = hex2num(copytext(new_skin, 2, 4))
						g_skin = hex2num(copytext(new_skin, 4, 6))
						b_skin = hex2num(copytext(new_skin, 6, 8))

				if("ooccolor")
					var/new_ooccolor = input(user, "Choose your OOC colour:", "Game Preference") as color|null
					if(new_ooccolor)
						ooccolor = new_ooccolor

				if("bag")
					var/new_backbag = input(user, "Choose your character's style of bag:", "Character Preference")  as null|anything in backbaglist
					if(new_backbag)
						backbag = backbaglist.Find(new_backbag)

				if("nt_relation")
					var/new_relation = input(user, "Choose your relation to NT. Note that this represents what others can find out about your character by researching your background, not what your character actually thinks.", "Character Preference")  as null|anything in list("Loyal", "Supportive", "Neutral", "Skeptical", "Opposed")
					if(new_relation)
						nanotrasen_relation = new_relation

				if("disabilities")
					if(text2num(href_list["disabilities"]) >= -1)
						if(text2num(href_list["disabilities"]) >= 0)
							disabilities ^= (1<<text2num(href_list["disabilities"])) //MAGIC
						SetDisabilities(user)
						return
					else
						user << browse(null, "window=disabil")

				if("limbs")
					var/limb_name = input(user, "Which limb do you want to change?") as null|anything in list("Left Leg","Right Leg","Left Arm","Right Arm","Left Foot","Right Foot","Left Hand","Right Hand")
					if(!limb_name) return

					var/limb = null
					var/second_limb = null // if you try to change the arm, the hand should also change
					var/third_limb = null  // if you try to unchange the hand, the arm should also change
					switch(limb_name)
						if("Left Leg")
							limb = "l_leg"
							second_limb = "l_foot"
						if("Right Leg")
							limb = "r_leg"
							second_limb = "r_foot"
						if("Left Arm")
							limb = "l_arm"
							second_limb = "l_hand"
						if("Right Arm")
							limb = "r_arm"
							second_limb = "r_hand"
						if("Left Foot")
							limb = "l_foot"
							third_limb = "l_leg"
						if("Right Foot")
							limb = "r_foot"
							third_limb = "r_leg"
						if("Left Hand")
							limb = "l_hand"
							third_limb = "l_arm"
						if("Right Hand")
							limb = "r_hand"
							third_limb = "r_arm"

					var/new_state = input(user, "What state do you wish the limb to be in?") as null|anything in list("Normal","Amputated","Prothesis")
					if(!new_state) return

					switch(new_state)
						if("Normal")
							organ_data[limb] = null
							if(third_limb)
								organ_data[third_limb] = null
						if("Amputated")
							organ_data[limb] = "amputated"
							if(second_limb)
								organ_data[second_limb] = "amputated"
						if("Prothesis")
							organ_data[limb] = "cyborg"
							if(second_limb)
								organ_data[second_limb] = "cyborg"
							if(third_limb && organ_data[third_limb] == "amputated")
								organ_data[third_limb] = null
				if("organs")
					var/organ_name = input(user, "Which internal function do you want to change?") as null|anything in list("Heart", "Eyes")
					if(!organ_name) return

					var/organ = null
					switch(organ_name)
						if("Heart")
							organ = "heart"
						if("Eyes")
							organ = "eyes"

					var/new_state = input(user, "What state do you wish the organ to be in?") as null|anything in list("Normal","Assisted","Mechanical")
					if(!new_state) return

					switch(new_state)
						if("Normal")
							organ_data[organ] = null
						if("Assisted")
							organ_data[organ] = "assisted"
						if("Mechanical")
							organ_data[organ] = "mechanical"

				if("skin_style")
					var/skin_style_name = input(user, "Select a new skin style") as null|anything in list("default1", "default2", "default3")
					if(!skin_style_name) return

				if("spawnpoint")
					var/list/spawnkeys = list()
					for(var/S in spawntypes)
						spawnkeys += S
					var/choice = input(user, "Where would you like to spawn when latejoining?") as null|anything in spawnkeys
					if(!choice || !spawntypes[choice])
						spawnpoint = "Arrivals Shuttle"
						return
					spawnpoint = choice

				if("home_system")
					var/choice = input(user, "Please choose a home system.") as null|anything in home_system_choices + list("Unset","Other")
					if(!choice)
						return
					if(choice == "Other")
						var/raw_choice = input(user, "Please enter a home system.")  as text|null
						if(raw_choice)
							home_system = sanitize(copytext(raw_choice,1,MAX_MESSAGE_LEN))
						return
					home_system = choice
				if("citizenship")
					var/choice = input(user, "Please choose your current citizenship.") as null|anything in citizenship_choices + list("None","Other")
					if(!choice)
						return
					if(choice == "Other")
						var/raw_choice = input(user, "Please enter your current citizenship.", "Character Preference") as text|null
						if(raw_choice)
							citizenship = sanitize(copytext(raw_choice,1,MAX_MESSAGE_LEN))
						return
					citizenship = choice
				if("faction")
					var/choice = input(user, "Please choose a faction to work for.") as null|anything in faction_choices + list("None","Other")
					if(!choice)
						return
					if(choice == "Other")
						var/raw_choice = input(user, "Please enter a faction.")  as text|null
						if(raw_choice)
							faction = sanitize(copytext(raw_choice,1,MAX_MESSAGE_LEN))
						return
					faction = choice
				if("religion")
					var/choice = input(user, "Please choose a religion.") as null|anything in religion_choices + list("None","Other")
					if(!choice)
						return
					if(choice == "Other")
						var/raw_choice = input(user, "Please enter a religon.")  as text|null
						if(raw_choice)
							religion = sanitize(copytext(raw_choice,1,MAX_MESSAGE_LEN))
						return
					religion = choice
		else
			switch(href_list["preference"])
				if("gender")
					if(gender == MALE)
						gender = FEMALE
					else
						gender = MALE

				if("disabilities")				//please note: current code only allows nearsightedness as a disability
					disabilities = !disabilities//if you want to add actual disabilities, code that selects them should be here

				if("hear_adminhelps")
					toggles ^= SOUND_ADMINHELP

				if("ui")
					switch(UI_style)
						if("White")
							UI_style = "old"
						if("old")
							UI_style = "White"

				if("UIcolor")
					var/UI_style_color_new = input(user, "Choose your UI color, dark colors are not recommended!") as color|null
					if(!UI_style_color_new) return
					UI_style_color = UI_style_color_new

				if("UIalpha")
					var/UI_style_alpha_new = input(user, "Select a new alpha(transparence) parametr for UI, between 50 and 255") as num
					if(!UI_style_alpha_new | !(UI_style_alpha_new <= 255 && UI_style_alpha_new >= 50)) return
					UI_style_alpha = UI_style_alpha_new

				if("be_special")
					var/num = text2num(href_list["num"])
					be_special ^= (1<<num)

				if("name")
					be_random_name = !be_random_name

				if("hear_midis")
					toggles ^= SOUND_MIDI

				if("lobby_music")
					toggles ^= SOUND_LOBBY
					if(toggles & SOUND_LOBBY)
						user << sound(ticker.login_music, repeat = 0, wait = 0, volume = 85, channel = 1)
					else
						user << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1)

				if("ghost_ears")
					toggles ^= CHAT_GHOSTEARS

				if("ghost_sight")
					toggles ^= CHAT_GHOSTSIGHT

				if("ghost_radio")
					toggles ^= CHAT_GHOSTRADIO

				if("save")
					save_preferences()
					save_character()

				if("reload")
					load_preferences()
					load_character()

				if("open_load_dialog")
					if(!IsGuestKey(user.key))
						open_load_dialog(user)

				if("close_load_dialog")
					close_load_dialog(user)

				if("changeslot")
					load_character(text2num(href_list["num"]))
					close_load_dialog(user)

	ShowChoices(user)
	return 1

/datum/preferences/proc/copy_to(mob/living/carbon/pony/character, safety = 0)
	if(be_random_name)
		real_name = random_name(gender,species)

	if(config.ponys_need_surnames)
		var/firstspace = findtext(real_name, " ")
		var/name_length = length(real_name)
		if(!firstspace)	//we need a surname
			real_name += " [pick(last_names)]"
		else if(firstspace == name_length)
			real_name += "[pick(last_names)]"

	character.real_name = real_name
	character.name = character.real_name
	if(character.dna)
		character.dna.real_name = character.real_name

	character.flavor_texts["general"] = flavor_texts["general"]
	character.flavor_texts["head"] = flavor_texts["head"]
	character.flavor_texts["face"] = flavor_texts["face"]
	character.flavor_texts["eyes"] = flavor_texts["eyes"]
	character.flavor_texts["torso"] = flavor_texts["torso"]
	character.flavor_texts["arms"] = flavor_texts["arms"]
	character.flavor_texts["hands"] = flavor_texts["hands"]
	character.flavor_texts["legs"] = flavor_texts["legs"]
	character.flavor_texts["feet"] = flavor_texts["feet"]

	character.med_record = med_record
	character.sec_record = sec_record
	character.gen_record = gen_record
	character.exploit_record = exploit_record

	character.gender = gender
	character.age = age
	character.b_type = b_type

	character.r_eyes = r_eyes
	character.g_eyes = g_eyes
	character.b_eyes = b_eyes

	character.r_hair = r_hair
	character.g_hair = g_hair
	character.b_hair = b_hair

	character.r_aura = r_aura
	character.g_aura = g_aura
	character.b_aura = b_aura

	character.r_facial = r_facial
	character.g_facial = g_facial
	character.b_facial = b_facial

	character.r_skin = r_skin
	character.g_skin = g_skin
	character.b_skin = b_skin

	character.r_tail = r_tail
	character.g_tail = g_tail
	character.b_tail = b_tail

	character.s_tone = s_tone

	character.h_style = h_style
	character.f_style = f_style

	character.home_system = home_system
	character.citizenship = citizenship
	character.personal_faction = faction
	character.religion = religion

	character.skills = skills
	character.used_skillpoints = used_skillpoints
	character.free_SP = free_SP
	character.total_SP = total_SP

	// Destroy/cyborgize organs


	for(var/name in organ_data)

		var/status = organ_data[name]
		var/datum/organ/external/O = character.organs_by_name[name]
		if(O)
			if(status == "amputated")
				O.amputated = 1
				O.status |= ORGAN_DESTROYED
				O.destspawn = 1
			else if(status == "cyborg")
				O.status |= ORGAN_ROBOT
		else
			var/datum/organ/internal/I = character.internal_organs_by_name[name]
			if(I)
				if(status == "assisted")
					I.mechassist()
				else if(status == "mechanical")
					I.mechanize()

	character.pony_tail_style = pony_tail_style

	character.cutie_mark = cutie_mark

	if(backbag > 4 || backbag < 1)
		backbag = 1 //Same as above
	character.backbag = backbag

	//Debugging report to track down a bug, which randomly assigned the plural gender to people.
	if(character.gender in list(PLURAL, NEUTER))
		if(isliving(src)) //Ghosts get neuter by default
			message_admins("[character] ([character.ckey]) has spawned with their gender as plural or neuter. Please notify coders.")
			character.gender = MALE

/datum/preferences/proc/open_load_dialog(mob/user)
	var/dat = "<body>"
	dat += "<tt><center>"

	var/savefile/S = new /savefile(path)
	if(S)
		dat += "<b>Select a character slot to load</b><hr>"
		var/name
		for(var/i=1, i<= config.character_slots, i++)
			S.cd = "/character[i]"
			S["real_name"] >> name
			if(!name)	name = "Character[i]"
			if(i==default_slot)
				name = "<b>[name]</b>"
			dat += "<a href='?_src_=prefs;preference=changeslot;num=[i];'>[name]</a><br>"

	dat += "<hr>"
	dat += "<a href='byond://?src=\ref[user];preference=close_load_dialog'>Close</a><br>"
	dat += "</center></tt>"
	user << browse(dat, "window=saves;size=300x390")

/datum/preferences/proc/close_load_dialog(mob/user)
	user << browse(null, "window=saves")
