/mob/living/carbon/pony/examine(mob/user)
	var/skipgloves = 0
	var/skipsuitstorage = 0
	var/skipjumpsuit = 0
	var/skipshoes = 0
	var/skipmask = 0
	var/skipears = 0
	var/skipeyes = 0
	var/skipface = 0

	//exosuits and helmets obscure our view and stuff.
	if(wear_suit)
		skipgloves = wear_suit.flags_inv & HIDEGLOVES
		skipsuitstorage = wear_suit.flags_inv & HIDESUITSTORAGE
		skipjumpsuit = wear_suit.flags_inv & HIDEJUMPSUIT
		skipshoes = wear_suit.flags_inv & HIDESHOES

	if(head)
		skipmask = head.flags_inv & HIDEMASK
		skipeyes = head.flags_inv & HIDEEYES
		skipears = head.flags_inv & HIDEEARS
		skipface = head.flags_inv & HIDEFACE

	if(wear_mask)
		skipface |= wear_mask.flags_inv & HIDEFACE

	// crappy hacks because you can't do \his[src] etc. I'm sorry this proc is so unreadable, blame the text macros :<
	var/t_He = "They" //capitalised for use at the start of each line.
	var/t_he = "they"
	var/t_his = "their"
	var/t_him = "them"
	var/t_has = "have"
	var/t_is = "are"
	var/t_does = "do"

	var/msg = "<span class='info'>*---------*\nThis is "

	//big suits/masks/helmets make it hard to tell their gender
	if(!skipjumpsuit || !skipface)
		if(icon)
			msg += "\icon[icon] " //fucking BYOND: this should stop dreamseeker crashing if we -somehow- examine somebody before their icon is generated
		switch(gender)
			if(MALE)
				t_He = "He"
				t_he = "he"
				t_his = "his"
				t_him = "him"
				t_has = "has"
				t_is = "is"
				t_does = "does"
			if(FEMALE)
				t_He = "She"
				t_he = "she"
				t_his = "her"
				t_him = "her"
				t_has = "has"
				t_is = "is"
				t_does = "does"
			if(NEUTER)
				t_He = "It"
				t_he = "it"
				t_his = "its"
				t_him = "it"
				t_has = "has"
				t_is = "is"
				t_does = "does"

	msg += "<EM>[src.name]</EM>"
	if(species.name != "Earthpony")
		msg += ", a <b><font color='[species.flesh_color]'>[species.name]</font></b>"
	msg += "!\n"

	//uniform
	if(w_uniform && !skipjumpsuit)
		//Ties
		var/tie_msg
		if(istype(w_uniform,/obj/item/clothing/under))
			var/obj/item/clothing/under/U = w_uniform
			if(U.accessories.len)
				tie_msg += ". Attached to it is [lowertext(english_list(U.accessories))]"

		if(w_uniform.blood_DNA)
			msg += "<span class='warning'>[t_He] [t_is] wearing \icon[w_uniform] [w_uniform.gender==PLURAL?"some":"a"] [(w_uniform.blood_color != "#030303") ? "blood" : "oil"]-stained [w_uniform.name][tie_msg]!</span>\n"
		else
			msg += "[t_He] [t_is] wearing \icon[w_uniform] \a [w_uniform][tie_msg].\n"

	//head
	if(head)
		if(head.blood_DNA)
			msg += "<span class='warning'>[t_He] [t_is] wearing \icon[head] [head.gender==PLURAL?"some":"a"] [(head.blood_color != "#030303") ? "blood" : "oil"]-stained [head.name] on [t_his] head!</span>\n"
		else
			msg += "[t_He] [t_is] wearing \icon[head] \a [head] on [t_his] head.\n"

	//suit/armour
	if(wear_suit)
		if(wear_suit.blood_DNA)
			msg += "<span class='warning'>[t_He] [t_is] wearing \icon[wear_suit] [wear_suit.gender==PLURAL?"some":"a"] [(wear_suit.blood_color != "#030303") ? "blood" : "oil"]-stained [wear_suit.name]!</span>\n"
		else
			msg += "[t_He] [t_is] wearing \icon[wear_suit] \a [wear_suit].\n"

		//suit/armour storage
		if(s_store && !skipsuitstorage)
			if(s_store.blood_DNA)
				msg += "<span class='warning'>[t_He] [t_is] carrying \icon[s_store] [s_store.gender==PLURAL?"some":"a"] [(s_store.blood_color != "#030303") ? "blood" : "oil"]-stained [s_store.name] on [t_his] [wear_suit.name]!</span>\n"
			else
				msg += "[t_He] [t_is] carrying \icon[s_store] \a [s_store] on [t_his] [wear_suit.name].\n"

	//back
	if(back)
		if(back.blood_DNA)
			msg += "<span class='warning'>[t_He] [t_has] \icon[back] [back.gender==PLURAL?"some":"a"] [(back.blood_color != "#030303") ? "blood" : "oil"]-stained [back] on [t_his] back.</span>\n"
		else
			msg += "[t_He] [t_has] \icon[back] \a [back] on [t_his] back.\n"

	//hands
	for(var/datum/hand/H in list_hands)
		if(H.item_in_hand)
			if(H.item_in_hand.blood_DNA)
				msg += "<span class='warning'>[t_He] [t_is] holding \icon[H.item_in_hand] [H.item_in_hand.gender==PLURAL?"some":"a"] [(H.item_in_hand.blood_color != "#030303") ? "blood" : "oil"]-stained [H.item_in_hand.name] in [t_his] left hand!</span>\n"
			else
				msg += "[t_He] [t_is] holding \icon[H.item_in_hand] \a [H.item_in_hand] in [t_his] left hand.\n"

	//gloves
	if(gloves && !skipgloves)
		if(gloves.blood_DNA)
			msg += "<span class='warning'>[t_He] [t_has] \icon[gloves] [gloves.gender==PLURAL?"some":"a"] [(gloves.blood_color != "#030303") ? "blood" : "oil"]-stained [gloves.name] on [t_his] hands!</span>\n"
		else
			msg += "[t_He] [t_has] \icon[gloves] \a [gloves] on [t_his] hands.\n"
	else if(blood_DNA)
		msg += "<span class='warning'>[t_He] [t_has] [(hand_blood_color != "#030303") ? "blood" : "oil"]-stained hands!</span>\n"

	//handcuffed?

	//handcuffed?
	if(handcuffed)
		if(istype(handcuffed, /obj/item/weapon/handcuffs/cable))
			msg += "<span class='warning'>[t_He] [t_is] \icon[handcuffed] restrained with cable!</span>\n"
		else
			msg += "<span class='warning'>[t_He] [t_is] \icon[handcuffed] handcuffed!</span>\n"

	//buckled
	if(buckled)
		msg += "<span class='warning'>[t_He] [t_is] \icon[buckled] buckled to [buckled]!</span>\n"

	//belt
	if(belt)
		if(belt.blood_DNA)
			msg += "<span class='warning'>[t_He] [t_has] \icon[belt] [belt.gender==PLURAL?"some":"a"] [(belt.blood_color != "#030303") ? "blood" : "oil"]-stained [belt.name] about [t_his] waist!</span>\n"
		else
			msg += "[t_He] [t_has] \icon[belt] \a [belt] about [t_his] waist.\n"

	//shoes
	if(shoes && !skipshoes)
		if(shoes.blood_DNA)
			msg += "<span class='warning'>[t_He] [t_is] wearing \icon[shoes] [shoes.gender==PLURAL?"some":"a"] [(shoes.blood_color != "#030303") ? "blood" : "oil"]-stained [shoes.name] on [t_his] feet!</span>\n"
		else
			msg += "[t_He] [t_is] wearing \icon[shoes] \a [shoes] on [t_his] feet.\n"
	else if(feet_blood_DNA)
		msg += "<span class='warning'>[t_He] [t_has] [(feet_blood_color != "#030303") ? "blood" : "oil"]-stained feet!</span>\n"

	//mask
	if(wear_mask && !skipmask)
		if(wear_mask.blood_DNA)
			msg += "<span class='warning'>[t_He] [t_has] \icon[wear_mask] [wear_mask.gender==PLURAL?"some":"a"] [(wear_mask.blood_color != "#030303") ? "blood" : "oil"]-stained [wear_mask.name] on [t_his] face!</span>\n"
		else
			msg += "[t_He] [t_has] \icon[wear_mask] \a [wear_mask] on [t_his] face.\n"

	//eyes
	if(glasses && !skipeyes)
		if(glasses.blood_DNA)
			msg += "<span class='warning'>[t_He] [t_has] \icon[glasses] [glasses.gender==PLURAL?"some":"a"] [(glasses.blood_color != "#030303") ? "blood" : "oil"]-stained [glasses] covering [t_his] eyes!</span>\n"
		else
			msg += "[t_He] [t_has] \icon[glasses] \a [glasses] covering [t_his] eyes.\n"

	//left ear
	if(l_ear && !skipears)
		msg += "[t_He] [t_has] \icon[l_ear] \a [l_ear] on [t_his] left ear.\n"

	//right ear
	if(r_ear && !skipears)
		msg += "[t_He] [t_has] \icon[r_ear] \a [r_ear] on [t_his] right ear.\n"

	//ID
	if(wear_id)
		/*var/id
		if(istype(wear_id, /obj/item/device/pda))
			var/obj/item/device/pda/pda = wear_id
			id = pda.owner
		else if(istype(wear_id, /obj/item/weapon/card/id)) //just in case something other than a PDA/ID card somehow gets in the ID slot :[
			var/obj/item/weapon/card/id/idcard = wear_id
			id = idcard.registered_name
		if(id && (id != real_name) && (get_dist(src, usr) <= 1) && prob(10))
			msg += "<span class='warning'>[t_He] [t_is] wearing \icon[wear_id] \a [wear_id] yet something doesn't seem right...</span>\n"
		else*/
		msg += "[t_He] [t_is] wearing \icon[wear_id] \a [wear_id].\n"

	//Jitters
	if(is_jittery)
		if(jitteriness >= 300)
			msg += "<span class='warning'><B>[t_He] [t_is] convulsing violently!</B></span>\n"
		else if(jitteriness >= 200)
			msg += "<span class='warning'>[t_He] [t_is] extremely jittery.</span>\n"
		else if(jitteriness >= 100)
			msg += "<span class='warning'>[t_He] [t_is] twitching ever so slightly.</span>\n"

	//splints
	for(var/organ in list("l_leg","r_leg","l_arm","r_arm"))
		var/datum/organ/external/o = get_organ(organ)
		if(o && o.status & ORGAN_SPLINTED)
			msg += "<span class='warning'>[t_He] [t_has] a splint on [t_his] [o.display_name]!</span>\n"

	if(suiciding)
		msg += "<span class='warning'>[t_He] appears to have commited suicide... there is no hope of recovery.</span>\n"

	if(mSmallsize in mutations)
		msg += "[t_He] [t_is] small halfling!\n"

	var/distance = get_dist(usr,src)
	if(istype(usr, /mob/dead/observer) || usr.stat == 2) // ghosts can see anything
		distance = 1
	if (src.stat)
		msg += "<span class='warning'>[t_He] [t_is]n't responding to anything around [t_him] and seems to be asleep.</span>\n"
		if((stat == 2 || src.losebreath) && distance <= 3)
			msg += "<span class='warning'>[t_He] [t_does] not appear to be breathing.</span>\n"
		if(istype(usr, /mob/living/carbon/pony) && !usr.stat && Adjacent(usr))
			usr.visible_message("<b>[usr]</b> checks [src]'s pulse.", "You check [src]'s pulse.")
		spawn(15)
			if(distance <= 1 && usr.stat != 1)
				if(pulse == PULSE_NONE)
					usr << "<span class='deadsay'>[t_He] [t_has] no pulse[src.client ? "" : " and [t_his] soul has departed"]...</span>"
				else
					usr << "<span class='deadsay'>[t_He] [t_has] a pulse!</span>"
	if(fire_stacks)
		msg += "[t_He] [t_is] covered in some liquid.\n"
	if(on_fire)
		msg += "<span class='warning'>[t_He] [t_is] on fire!.</span>\n"
	msg += "<span class='warning'>"

	if(nutrition < 100)
		msg += "[t_He] [t_is] severely malnourished.\n"
	else if(nutrition >= 500)
		/*if(usr.nutrition < 100)
			msg += "[t_He] [t_is] plump and delicious looking - Like a fat little piggy. A tasty piggy.\n"
		else*/
		msg += "[t_He] [t_is] quite chubby.\n"

	msg += "</span>"

	if(getBrainLoss() >= 60)
		msg += "[t_He] [t_has] a stupid expression on [t_his] face.\n"

	if((!species.has_organ["brain"] || has_brain()) && stat != DEAD)
		if(!key)
			msg += "<span class='deadsay'>[t_He] [t_is] fast asleep. It doesn't look like [t_he] [t_is] waking up anytime soon.</span>\n"
		else if(!client)
			msg += "[t_He] [t_has] suddenly fallen asleep.\n"

	var/list/wound_flavor_text = list()
	var/list/is_destroyed = list()
	var/list/is_bleeding = list()
	for(var/datum/organ/external/temp in organs)
		if(temp)
			if(temp.status & ORGAN_DESTROYED)
				is_destroyed["[temp.display_name]"] = 1
				wound_flavor_text["[temp.display_name]"] = "<span class='warning'><b>[t_He] [t_is] missing [t_his] [temp.display_name].</b></span>\n"
				continue
			if(temp.status & ORGAN_ROBOT)
				if(!(temp.brute_dam + temp.burn_dam))
					if(!species.flags & IS_SYNTHETIC)
						wound_flavor_text["[temp.display_name]"] = "<span class='warning'>[t_He] [t_has] a robot [temp.display_name]!</span>\n"
						continue
				else
					wound_flavor_text["[temp.display_name]"] = "<span class='warning'>[t_He] [t_has] a robot [temp.display_name]. It has"
				if(temp.brute_dam) switch(temp.brute_dam)
					if(0 to 20)
						wound_flavor_text["[temp.display_name]"] += " some dents"
					if(21 to INFINITY)
						wound_flavor_text["[temp.display_name]"] += pick(" a lot of dents"," severe denting")
				if(temp.brute_dam && temp.burn_dam)
					wound_flavor_text["[temp.display_name]"] += " and"
				if(temp.burn_dam) switch(temp.burn_dam)
					if(0 to 20)
						wound_flavor_text["[temp.display_name]"] += " some burns"
					if(21 to INFINITY)
						wound_flavor_text["[temp.display_name]"] += pick(" a lot of burns"," severe melting")
				if(wound_flavor_text["[temp.display_name]"])
					wound_flavor_text["[temp.display_name]"] += "!</span>\n"
			else if(temp.wounds.len > 0)
				var/list/wound_descriptors = list()
				for(var/datum/wound/W in temp.wounds)
					if(W.internal && !temp.open) continue // can't see internal wounds
					var/this_wound_desc = W.desc
					if(W.damage_type == BURN && W.salved) this_wound_desc = "salved [this_wound_desc]"
					if(W.bleeding()) this_wound_desc = "bleeding [this_wound_desc]"
					else if(W.bandaged) this_wound_desc = "bandaged [this_wound_desc]"
					if(W.germ_level > 600) this_wound_desc = "badly infected [this_wound_desc]"
					else if(W.germ_level > 330) this_wound_desc = "lightly infected [this_wound_desc]"
					if(this_wound_desc in wound_descriptors)
						wound_descriptors[this_wound_desc] += W.amount
						continue
					wound_descriptors[this_wound_desc] = W.amount
				if(wound_descriptors.len)
					var/list/flavor_text = list()
					var/list/no_exclude = list("gaping wound", "big gaping wound", "massive wound", "large bruise",\
					"huge bruise", "massive bruise", "severe burn", "large burn", "deep burn", "carbonised area")
					for(var/wound in wound_descriptors)
						switch(wound_descriptors[wound])
							if(1)
								if(!flavor_text.len)
									flavor_text += "<span class='warning'>[t_He] [t_has][prob(10) && !(wound in no_exclude)  ? " what might be" : ""] a [wound]"
								else
									flavor_text += "[prob(10) && !(wound in no_exclude) ? " what might be" : ""] a [wound]"
							if(2)
								if(!flavor_text.len)
									flavor_text += "<span class='warning'>[t_He] [t_has][prob(10) && !(wound in no_exclude) ? " what might be" : ""] a pair of [wound]s"
								else
									flavor_text += "[prob(10) && !(wound in no_exclude) ? " what might be" : ""] a pair of [wound]s"
							if(3 to 5)
								if(!flavor_text.len)
									flavor_text += "<span class='warning'>[t_He] [t_has] several [wound]s"
								else
									flavor_text += " several [wound]s"
							if(6 to INFINITY)
								if(!flavor_text.len)
									flavor_text += "<span class='warning'>[t_He] [t_has] a bunch of [wound]s"
								else
									flavor_text += " a ton of [wound]\s"
					var/flavor_text_string = ""
					for(var/text = 1, text <= flavor_text.len, text++)
						if(text == flavor_text.len && flavor_text.len > 1)
							flavor_text_string += ", and"
						else if(flavor_text.len > 1 && text > 1)
							flavor_text_string += ","
						flavor_text_string += flavor_text[text]
					flavor_text_string += " on [t_his] [temp.display_name].</span><br>"
					wound_flavor_text["[temp.display_name]"] = flavor_text_string
				else
					wound_flavor_text["[temp.display_name]"] = ""
				if(temp.status & ORGAN_BLEEDING)
					is_bleeding["[temp.display_name]"] = 1
			else
				wound_flavor_text["[temp.display_name]"] = ""

	//Handles the text strings being added to the actual description.
	//If they have something that covers the limb, and it is not missing, put flavortext.  If it is covered but bleeding, add other flavortext.
	var/display_chest = 0
	var/display_shoes = 0
	var/display_gloves = 0
	if(wound_flavor_text["head"] && (is_destroyed["head"] || (!skipmask && !(wear_mask && istype(wear_mask, /obj/item/clothing/mask/gas)))))
		msg += wound_flavor_text["head"]
	else if(is_bleeding["head"])
		msg += "<span class='warning'>[src] [t_has] blood running down [t_his] face!</span>\n"
	if(wound_flavor_text["chest"] && !w_uniform && !skipjumpsuit) //No need.  A missing chest gibs you.
		msg += wound_flavor_text["chest"]
	else if(is_bleeding["chest"])
		display_chest = 1
	if(wound_flavor_text["left arm"] && (is_destroyed["left arm"] || (!w_uniform && !skipjumpsuit)))
		msg += wound_flavor_text["left arm"]
	else if(is_bleeding["left arm"])
		display_chest = 1
	if(wound_flavor_text["left hand"] && (is_destroyed["left hand"] || (!gloves && !skipgloves)))
		msg += wound_flavor_text["left hand"]
	else if(is_bleeding["left hand"])
		display_gloves = 1
	if(wound_flavor_text["right arm"] && (is_destroyed["right arm"] || (!w_uniform && !skipjumpsuit)))
		msg += wound_flavor_text["right arm"]
	else if(is_bleeding["right arm"])
		display_chest = 1
	if(wound_flavor_text["right hand"] && (is_destroyed["right hand"] || (!gloves && !skipgloves)))
		msg += wound_flavor_text["right hand"]
	else if(is_bleeding["right hand"])
		display_gloves = 1
	if(wound_flavor_text["groin"] && (is_destroyed["groin"] || (!w_uniform && !skipjumpsuit)))
		msg += wound_flavor_text["groin"]
	else if(is_bleeding["groin"])
		display_chest = 1
	if(wound_flavor_text["left leg"] && (is_destroyed["left leg"] || (!w_uniform && !skipjumpsuit)))
		msg += wound_flavor_text["left leg"]
	else if(is_bleeding["left leg"])
		display_chest = 1
	if(wound_flavor_text["left foot"]&& (is_destroyed["left foot"] || (!shoes && !skipshoes)))
		msg += wound_flavor_text["left foot"]
	else if(is_bleeding["left foot"])
		display_shoes = 1
	if(wound_flavor_text["right leg"] && (is_destroyed["right leg"] || (!w_uniform && !skipjumpsuit)))
		msg += wound_flavor_text["right leg"]
	else if(is_bleeding["right leg"])
		display_chest = 1
	if(wound_flavor_text["right foot"]&& (is_destroyed["right foot"] || (!shoes  && !skipshoes)))
		msg += wound_flavor_text["right foot"]
	else if(is_bleeding["right foot"])
		display_shoes = 1
	if(display_chest)
		msg += "<span class='danger'>[src] [t_has] blood soaking through from under [t_his] clothing!</span>\n"
	if(display_shoes)
		msg += "<span class='danger'>[src] [t_has] blood running from [t_his] shoes!</span>\n"
	if(display_gloves)
		msg += "<span class='danger'>[src] [t_has] blood running from under [t_his] gloves!</span>\n"

	for(var/implant in get_visible_implants(0))
		msg += "<span class='danger'>[src] [t_has] \a [implant] sticking out of [t_his] flesh!</span>\n"
	if(digitalcamo)
		msg += "[t_He] [t_is] repulsively uncanny!\n"


	if(hasHUD(usr,"security"))
		var/perpname = "wot"
		var/criminal = "None"

		if(wear_id)
			var/obj/item/weapon/card/id/I = wear_id.GetID()
			if(I)
				perpname = I.registered_name
			else
				perpname = name
		else
			perpname = name

		if(perpname)
			for (var/datum/data/record/E in data_core.general)
				if(E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.security)
						if(R.fields["id"] == E.fields["id"])
							criminal = R.fields["criminal"]

			msg += "<span class = 'deptradio'>Criminal status:</span> <a href='?src=\ref[src];criminal=1'>\[[criminal]\]</a>\n"
			msg += "<span class = 'deptradio'>Security records:</span> <a href='?src=\ref[src];secrecord=`'>\[View\]</a>  <a href='?src=\ref[src];secrecordadd=`'>\[Add comment\]</a>\n"

	if(hasHUD(usr,"medical"))
		var/perpname = "wot"
		var/medical = "None"

		if(wear_id)
			if(istype(wear_id,/obj/item/weapon/card/id))
				perpname = wear_id:registered_name
			else if(istype(wear_id,/obj/item/device/pda))
				var/obj/item/device/pda/tempPda = wear_id
				perpname = tempPda.owner
		else
			perpname = src.name

		for (var/datum/data/record/E in data_core.general)
			if (E.fields["name"] == perpname)
				for (var/datum/data/record/R in data_core.general)
					if (R.fields["id"] == E.fields["id"])
						medical = R.fields["p_stat"]

		msg += "<span class = 'deptradio'>Physical status:</span> <a href='?src=\ref[src];medical=1'>\[[medical]\]</a>\n"
		msg += "<span class = 'deptradio'>Medical records:</span> <a href='?src=\ref[src];medrecord=`'>\[View\]</a> <a href='?src=\ref[src];medrecordadd=`'>\[Add comment\]</a>\n"


	if(print_flavor_text()) msg += "[print_flavor_text()]\n"

	msg += "*---------*</span>"
	if (pose)
		if( findtext(pose,".",length(pose)) == 0 && findtext(pose,"!",length(pose)) == 0 && findtext(pose,"?",length(pose)) == 0 )
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		msg += "\n[t_He] [t_is] [pose]"

	user << msg

//Helper procedure. Called by /mob/living/carbon/pony/examine() and /mob/living/carbon/pony/Topic() to determine HUD access to security and medical records.
/proc/hasHUD(mob/M as mob, hudtype)
	if(istype(M, /mob/living/carbon/pony))
		var/mob/living/carbon/pony/H = M
		switch(hudtype)
			if("security")
				return istype(H.glasses, /obj/item/clothing/glasses/hud/security) || istype(H.glasses, /obj/item/clothing/glasses/sunglasses/sechud)
			if("medical")
				return istype(H.glasses, /obj/item/clothing/glasses/hud/health)
			else
				return 0
	else if(istype(M, /mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = M
		switch(hudtype)
			if("security")
				return istype(R.module_state_1, /obj/item/borg/sight/hud/sec) || istype(R.module_state_2, /obj/item/borg/sight/hud/sec) || istype(R.module_state_3, /obj/item/borg/sight/hud/sec)
			if("medical")
				return istype(R.module_state_1, /obj/item/borg/sight/hud/med) || istype(R.module_state_2, /obj/item/borg/sight/hud/med) || istype(R.module_state_3, /obj/item/borg/sight/hud/med)
			else
				return 0
	else
		return 0
