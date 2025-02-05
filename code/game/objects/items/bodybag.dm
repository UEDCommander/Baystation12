//Also contains /obj/structure/closet/body_bag because I doubt anyone would think to look for bodybags in /object/structures

/obj/item/bodybag
	name = "body bag"
	desc = "A folded bag designed for the storage and transportation of cadavers."
	icon = 'icons/obj/closets/bodybag.dmi'
	icon_state = "bodybag_folded"
	w_class = ITEM_SIZE_SMALL
	attack_self(mob/user)
		var/obj/structure/closet/body_bag/R = new /obj/structure/closet/body_bag(user.loc)
		R.add_fingerprint(user)
		qdel(src)

	ex_act(severity)
		switch(severity)
			if(1)
				for(var/atom/movable/A in src)//pulls everything out of the locker and hits it with an explosion
					A.forceMove(src.loc)
					A.ex_act(severity + 1)
				qdel(src)
			if(2)
				if(prob(90))
					for (var/atom/movable/A in src)
						A.forceMove(src.loc)
						A.ex_act(severity + 1)
					qdel(src)
			if(3)
				if(prob(70))
					for(var/atom/movable/A in src)
						A.forceMove(src.loc)
					qdel(src)

/obj/item/storage/box/bodybags
	name = "body bags"
	desc = "This box contains body bags."
	icon_state = "bodybags"
	New()
		..()
		new /obj/item/bodybag(src)
		new /obj/item/bodybag(src)
		new /obj/item/bodybag(src)
		new /obj/item/bodybag(src)
		new /obj/item/bodybag(src)
		new /obj/item/bodybag(src)
		new /obj/item/bodybag(src)


/obj/structure/closet/body_bag
	name = "body bag"
	desc = "A plastic bag designed for the storage and transportation of cadavers."
	icon = 'icons/obj/closets/bodybag.dmi'
	icon_state = "bodybag"
	open_sound = 'sound/items/zip.ogg'
	close_sound = 'sound/items/zip.ogg'
	var/item_path = /obj/item/bodybag
	density = FALSE
	storage_capacity = (MOB_MEDIUM * 2) - 1
	var/contains_body = 0
	var/has_label = FALSE

/obj/structure/closet/body_bag/attackby(var/obj/item/W, mob/user as mob)
	if (istype(W, /obj/item/pen))
		var/t = input(user, "What would you like the label to be?", text("[]", src.name), null)  as text
		if (user.get_active_hand() != W)
			return
		if (!in_range(src, user) && src.loc != user)
			return
		t = sanitizeSafe(t, MAX_NAME_LEN)
		if (t)
			src.SetName("body bag - ")
			src.name += t
			has_label = TRUE
		else
			src.SetName("body bag")

		return
	else if(isWirecutter(W))
		src.SetName("body bag")
		has_label = FALSE
		to_chat(user, "You cut the tag off \the [src].")
		src.update_icon()
		return

/obj/structure/closet/body_bag/on_update_icon()
	icon_state = "[initial(icon_state)][opened ? "_open" : "[contains_body ? "_occupied" : ""]"]"
	//src.overlays.Cut()

	if(has_label)
		src.overlays += image(src.icon, "bodybag_label")

/obj/structure/closet/body_bag/animate_door()

	flick("[initial(icon_state)]_anim_[opened ? "open" : "close"]", src)

/obj/structure/closet/body_bag/store_mobs(var/stored_units)
	contains_body = ..()
	return contains_body

/obj/structure/closet/body_bag/close()
	if(..())
		set_density(0)
		return 1
	return 0

/obj/structure/closet/body_bag/proc/fold(var/user)
	if(!(ishuman(user) || isrobot(user)))
		to_chat(user, SPAN_NOTICE("You lack the dexterity to close \the [name]."))
		return FALSE

	if(opened)
		to_chat(user, SPAN_NOTICE("You must close \the [name] before it can be folded."))
		return FALSE

	if(contents.len)
		to_chat(user, SPAN_NOTICE("You can't fold \the [name] while it has something inside it."))
		return FALSE

	visible_message("[user] folds up the [name]")
	. = new item_path(get_turf(src))
	qdel(src)

/obj/structure/closet/body_bag/MouseDrop(over_object, src_location, over_location)
	..()
	if((over_object == usr && (in_range(src, usr) || list_find(usr.contents, src))))
		fold(usr)

/obj/item/robot_rack/body_bag
	name = "stasis bag rack"
	desc = "A rack for carrying folded stasis bags and body bags."
	icon = 'icons/obj/closets/cryobag.dmi'
	icon_state = "bodybag_folded"
	object_type = /obj/item/bodybag
	interact_type = /obj/structure/closet/body_bag
	capacity = 3
