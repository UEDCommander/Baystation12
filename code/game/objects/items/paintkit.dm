/obj/item/device/kit
	icon_state = "modkit"
	icon = 'icons/obj/device.dmi'
	var/new_name = "exosuit"    //What is the variant called?
	var/new_desc = "An exosuit." //How is the new exosuit described?
	var/new_icon = "ripley"  //What base icon will the new exosuit use?
	var/new_icon_file

/obj/item/device/kit/inherit_custom_item_data(var/datum/custom_item/citem)
	new_name = citem.item_name
	new_desc = citem.item_desc
	new_icon = citem.item_icon_state
	new_icon_file = CUSTOM_ITEM_OBJ
	. = src

/obj/item/device/kit/proc/use(var/mob/user)
	playsound(get_turf(user), 'sound/items/Screwdriver.ogg', 50, 1)

// Root hardsuit kit defines.
// Icons for modified hardsuits need to be in the proper .dmis because suit cyclers may cock them up.
/obj/item/device/kit/suit
	name = "voidsuit modification kit"
	desc = "A kit for modifying a voidsuit."
	var/new_light_overlay
	var/new_mob_icon_file

/obj/item/device/kit/suit/inherit_custom_item_data(var/datum/custom_item/citem)
	. = ..()
	if(citem.additional_data["light_overlay"])
		new_light_overlay = citem.additional_data["light_overlay"]
	new_mob_icon_file = CUSTOM_ITEM_MOB

/obj/item/clothing/head/helmet/space/void/attackby(var/obj/item/O, var/mob/user)
	if(istype(O,/obj/item/device/kit/suit))
		var/obj/item/device/kit/suit/kit = O
		SetName("[kit.new_name] suit helmet")
		desc = kit.new_desc
		icon_state = "[kit.new_icon]_helmet"
		item_state = "[kit.new_icon]_helmet"
		if(kit.new_icon_file)
			icon = kit.new_icon_file
		if(kit.new_mob_icon_file)
			icon_override = kit.new_mob_icon_file
		if(kit.new_light_overlay)
			light_overlay = kit.new_light_overlay
		to_chat(user, "You set about modifying the helmet into [src].")
		var/mob/living/carbon/human/H = user
		if(istype(H))
			species_restricted = list(H.species.get_bodytype(H))
		kit.use(1,user)
		return 1
	return ..()

/obj/item/clothing/suit/space/void/attackby(var/obj/item/O, var/mob/user)
	if(istype(O,/obj/item/device/kit/suit))
		var/obj/item/device/kit/suit/kit = O
		SetName("[kit.new_name] voidsuit")
		desc = kit.new_desc
		icon_state = "[kit.new_icon]_suit"
		item_state = "[kit.new_icon]_suit"
		if(kit.new_icon_file)
			icon = kit.new_icon_file
		if(kit.new_mob_icon_file)
			icon_override = kit.new_mob_icon_file
		to_chat(user, "You set about modifying the suit into [src].")
		var/mob/living/carbon/human/H = user
		if(istype(H))
			species_restricted = list(H.species.get_bodytype(H))
		kit.use(1,user)
		return 1
	return ..()

// Mechs are handled in their attackby (mech_interaction.dm).
/obj/item/device/kit/mech
	name = "exosuit customization kit"
	desc = "A kit containing all the needed tools and parts to repaint a exosuit."
	var/removable = null
	new_icon_file = 'icons/mecha/mech_decals.dmi'
	var/current_decal = "cammo2" //По умолчанию
	var/list/mech_decales = list(
		"flames_red",
		"flames_blue",
		"cammo2",
		"cammo1",
		"red_stripes",
		"white_stripes",
		"black_stripes",
		"green_stripes",
	)

/obj/item/device/kit/mech/attack_self(mob/user)//Тыкаем по самому киту дабы вызвать список того, какую декаль хотим на меха
	choose_decal(user)

/obj/item/device/kit/mech/examine(mob/user)
	. = ..()
	to_chat(user, "This kit will add a '[new_name]' decal to a exosuit'.")

/obj/item/device/kit/mech/proc/choose_decal(mob/user)
	set name = "Choose decal"
	set desc = "Choose mech decal."
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		return
	var/new_decal = input(usr, "Choose a decal.", name, current_decal) as null|anything in mech_decales
	if (usr.incapacitated())
		return
	change_decal(new_decal, usr)

/obj/item/device/kit/mech/proc/change_decal(var/new_decal, mob/user)
	current_decal = new_decal
	new_name = new_decal
	to_chat(user, SPAN_NOTICE("You set \the [src] to customize with [new_decal]."))
	playsound(src, 'sound/weapons/flipblade.ogg', 30, 1)
