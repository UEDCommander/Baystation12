/mob/living/chorus/Life()
	if(stat != DEAD && health <= 0)
		death()
	. = ..()

/mob/living/chorus/death()
	..()
	playsound(src, 'sound/hallucinations/wail.ogg', 100, 1)
<<<<<<< HEAD
	icon_state = "[icon_state]_death"
=======
	icon_state = "[icon_state]_death"
>>>>>>> master
