/client/proc/mod_list_add_ass() //haha
	var/class = "text"

	var/list/possible_classes = list("text","num","type","reference","mob reference","icon","file","list")
	if(LAZYLEN(stored_matrices))
		possible_classes += "matrix"
	if(admin_holder && admin_holder.marked_datums.len)
		possible_classes += "marked datum"
	possible_classes += "edit referenced object"
	possible_classes += "restore to default"

	class = tgui_input_list(usr, "What kind of variable?","Variable Type", possible_classes)
	if(!class)
		return

	var/var_value = null

	switch(class)

		if("text")
			var_value = input("Enter new text:","Text") as null|text

		if("num")
			var_value = tgui_input_real_number(src, "Enter new number:","Num")

		if("type")
			var_value = tgui_input_list(usr, "Enter type:","Type", typesof(/obj,/mob,/area,/turf))

		if("reference")
			var_value = input("Select reference:","Reference") as null|mob|obj|turf|area in world

		if("mob reference")
			var_value = input("Select reference:","Reference") as null|mob in GLOB.mob_list

		if("file")
			var_value = input("Pick file:","File") as null|file

		if("icon")
			var_value = input("Pick icon:","Icon") as null|icon

		if("matrix")
			var/matrix_name = tgui_input_list(usr, "Choose a matrix", "Matrix", (stored_matrices + "Cancel"))
			if(!matrix_name || matrix_name == "Cancel")
				return

			var/matrix/M = LAZYACCESS(stored_matrices, matrix_name)
			if(!M)
				return

			var_value = M

		if("marked datum")
			var/datum/D = input_marked_datum(admin_holder.marked_datums)
			var_value = D

	if(!var_value) return

	return var_value


/client/proc/mod_list_add(list/L)

	var/class = "text"

	var/list/possible_classes = list("text","num","type","reference","mob reference","icon","file","list")
	if(LAZYLEN(stored_matrices))
		possible_classes += "matrix"
	if(admin_holder && admin_holder.marked_datums.len)
		possible_classes += "marked datum"
	possible_classes += "edit referenced object"
	possible_classes += "restore to default"

	class = tgui_input_list(usr, "What kind of variable?","Variable Type", possible_classes)
	if(!class)
		return

	if(!class)
		return

	var/var_value = null

	switch(class)

		if("text")
			var_value = input("Enter new text:","Text") as text

		if("num")
			var_value = tgui_input_real_number(usr, "Enter new number:","Num")

		if("type")
			var_value = tgui_input_list(usr, "Enter type:","Type", typesof(/obj,/mob,/area,/turf))

		if("reference")
			var_value = input("Select reference:","Reference") as mob|obj|turf|area in world

		if("mob reference")
			var_value = input("Select reference:","Reference") as mob in GLOB.mob_list

		if("file")
			var_value = input("Pick file:","File") as file

		if("icon")
			var_value = input("Pick icon:","Icon") as icon

		if("matrix")
			var/matrix_name = tgui_input_list(usr, "Choose a matrix", "Matrix", (stored_matrices + "Cancel"))
			if(!matrix_name || matrix_name == "Cancel")
				return

			var/matrix/M = LAZYACCESS(stored_matrices, matrix_name)
			if(!M)
				return

			var_value = M

		if("marked datum")
			var/datum/D = input_marked_datum(admin_holder.marked_datums)
			var_value = D

	if(!var_value) return

	switch(alert("Would you like to associate a var with the list entry?",,"Yes","No"))
		if("Yes")
			L += var_value
			L[var_value] = mod_list_add_ass() //haha
		if("No")
			L += var_value

	message_staff("[key_name_admin(src)] added a new element to a list with a key of '[var_value]' and an associated value of [isnum(var_value)? "null" : L[var_value]]", 1)

/client/proc/mod_list(list/L)
	if(!check_rights(R_VAREDIT)) return

	if(!istype(L,/list)) to_chat(src, "Not a List.")

	var/list/locked = list("vars", "key", "ckey", "client", "icon")
	var/list/names = sortList(L)

	var/variable = tgui_input_list(usr, "Which var?","Var", names + "(ADD VAR)")

	if(variable == "(ADD VAR)")
		mod_list_add(L)
		return

	if(!variable)
		return

	var/default

	var/dir

	if(variable in locked)
		if(!check_rights(R_DEBUG)) return

	if(isnull(variable))
		to_chat(usr, "Unable to determine variable type.")

	else if(isnum(variable))
		to_chat(usr, "Variable appears to be <b>NUM</b>.")

		dir = 1

	else if(istext(variable))
		to_chat(usr, "Variable appears to be <b>TEXT</b>.")


	else if(isloc(variable))
		to_chat(usr, "Variable appears to be <b>REFERENCE</b>.")


	else if(isicon(variable))
		to_chat(usr, "Variable appears to be <b>ICON</b>.")
		variable = "[icon2html(variable, usr)]"


	else if(istype(variable,/matrix))
		to_chat(usr, "Variable appears to be <b>MATRIX</b>.")


	else if(istype(variable,/atom) || istype(variable,/datum))
		to_chat(usr, "Variable appears to be <b>TYPE</b>.")


	else if(istype(variable,/list))
		to_chat(usr, "Variable appears to be <b>LIST</b>.")


	else if(istype(variable,/client))
		to_chat(usr, "Variable appears to be <b>CLIENT</b>.")


	else
		to_chat(usr, "Variable appears to be <b>FILE</b>.")


	to_chat(usr, "Variable contains: [variable]")
	if(dir)
		switch(variable)
			if(1)
				dir = "NORTH"
			if(2)
				dir = "SOUTH"
			if(4)
				dir = "EAST"
			if(8)
				dir = "WEST"
			if(5)
				dir = "NORTHEAST"
			if(6)
				dir = "SOUTHEAST"
			if(9)
				dir = "NORTHWEST"
			if(10)
				dir = "SOUTHWEST"
			else
				dir = null

		if(dir)
			to_chat(usr, "If a direction, direction is: [dir]")

	var/class = "text"

	var/list/choices = list("text","num","type","reference","mob reference","icon","file","list")
	if(LAZYLEN(stored_matrices))
		choices += "matrix"
	if(admin_holder && admin_holder.marked_datums.len)
		choices += "marked datum"
	choices += "edit referenced object"
	choices += "restore to default"

	if(!isnull(default) && default != "num")
		choices += "edit associated variable"
	choices += "DELETE FROM LIST"

	class = tgui_input_list(usr, "What kind of variable?","Variable Type", choices)

	if(!class)
		return

	switch(class) //Spits a runtime error if you try to modify an entry in the contents list. Dunno how to fix it, yet.

		if("list")
			mod_list(variable)

		if("restore to default")
			L[L.Find(variable)]=initial(variable)

		if("edit referenced object")
			modify_variables(variable)

		if("DELETE FROM LIST")
			L -= variable
			return

		if("text")
			L[L.Find(variable)] = input("Enter new text:","Text") as text

		if("num")
			L[L.Find(variable)] = tgui_input_real_number(usr, "Enter new number:","Num")

		if("type")
			L[L.Find(variable)] = tgui_input_list(usr, "Enter type:","Type", typesof(/obj,/mob,/area,/turf))

		if("reference")
			L[L.Find(variable)] = input("Select reference:","Reference") as mob|obj|turf|area in world

		if("mob reference")
			L[L.Find(variable)] = input("Select reference:","Reference") as mob in GLOB.mob_list

		if("file")
			L[L.Find(variable)] = input("Pick file:","File") as file

		if("icon")
			L[L.Find(variable)] = input("Pick icon:","Icon") as icon

		if("matrix")
			var/matrix_name = tgui_input_list(usr, "Choose a matrix", "Matrix", (stored_matrices + "Cancel"))
			if(!matrix_name || matrix_name == "Cancel")
				return

			var/matrix/M = LAZYACCESS(stored_matrices, matrix_name)
			if(!M)
				return

			L[L.Find(variable)] = M

		if("marked datum")
			var/datum/D = input_marked_datum(admin_holder.marked_datums)
			L[L.Find(variable)] = D

		if("edit associated variable")
			var/temp_var = mod_list_add_ass()
			if(temp_var)
				L[variable] = temp_var

	message_staff("[key_name_admin(src)] modified a list's '[variable]': [L.Find(variable)] => [L[L.Find(variable)]]", 1)


/client/proc/modify_variables(atom/O, param_var_name = null, autodetect_class = 0)
	if(!check_rights(R_VAREDIT)) return

	var/list/locked = list("vars", "key", "ckey", "client", "icon")

	if(O.is_datum_protected())
		to_chat(usr, SPAN_WARNING("This datum is protected. Access Denied"))
		return

	if(!O.can_vv_modify() && !(admin_holder.rights & R_DEBUG))
		to_chat(usr, "You can't modify this object! You require debugging permission")
		return

	var/class
	var/variable
	var/var_value

	if(param_var_name)
		if(!(param_var_name in O.vars))
			to_chat(src, "A variable with this name ([param_var_name]) doesn't exist in this atom ([O])")
			return

		if(param_var_name == "admin_holder" || (param_var_name in locked))
			if(!check_rights(R_DEBUG)) return

		variable = param_var_name

		var_value = O.vars[variable]

		if(autodetect_class)
			if(isnull(var_value))
				to_chat(usr, "Unable to determine variable type.")
				class = null
				autodetect_class = null
			else if(isnum(var_value))
				to_chat(usr, "Variable appears to be <b>NUM</b>.")
				class = "num"
				dir = 1

			else if(istext(var_value))
				to_chat(usr, "Variable appears to be <b>TEXT</b>.")
				class = "text"

			else if(isloc(var_value))
				to_chat(usr, "Variable appears to be <b>REFERENCE</b>.")
				class = "reference"

			else if(isicon(var_value))
				to_chat(usr, "Variable appears to be <b>ICON</b>.")
				var_value = "\icon[var_value]"
				class = "icon"

			else if(istype(var_value,/matrix))
				to_chat(usr, "Variable appears to be <b>MATRIX</b>.")
				class = "matrix"

			else if(istype(var_value,/atom) || istype(var_value,/datum))
				to_chat(usr, "Variable appears to be <b>TYPE</b>.")
				class = "type"

			else if(istype(var_value,/list))
				to_chat(usr, "Variable appears to be <b>LIST</b>.")
				class = "list"

			else if(istype(var_value,/client))
				to_chat(usr, "Variable appears to be <b>CLIENT</b>.")
				class = "cancel"
			else
				to_chat(usr, "Variable appears to be <b>FILE</b>.")
				class = "file"

	else

		var/list/names = list()
		for (var/V in O.vars)
			names += V

		names = sortList(names)

		variable = tgui_input_list(usr, "Which var?","Var", names)
		if(!variable)
			return

		var_value = O.vars[variable]

		if(variable == "admin_holder" || (variable in locked))
			if(!check_rights(R_DEBUG)) return

	if(!autodetect_class)

		var/dir
		if(isnull(var_value))
			to_chat(usr, "Unable to determine variable type.")

		else if(isnum(var_value))
			to_chat(usr, "Variable appears to be <b>NUM</b>.")

			dir = 1

		else if(istext(var_value))
			to_chat(usr, "Variable appears to be <b>TEXT</b>.")


		else if(isloc(var_value))
			to_chat(usr, "Variable appears to be <b>REFERENCE</b>.")


		else if(isicon(var_value))
			to_chat(usr, "Variable appears to be <b>ICON</b>.")
			var_value = "\icon[var_value]"


		else if(istype(var_value,/matrix))
			to_chat(usr, "Variable appears to be <b>MATRIX</b>.")
			class = "matrix"

		else if(istype(var_value,/atom) || istype(var_value,/datum))
			to_chat(usr, "Variable appears to be <b>TYPE</b>.")


		else if(istype(var_value,/list))
			to_chat(usr, "Variable appears to be <b>LIST</b>.")


		else if(istype(var_value,/client))
			to_chat(usr, "Variable appears to be <b>CLIENT</b>.")


		else
			to_chat(usr, "Variable appears to be <b>FILE</b>.")


		to_chat(usr, "Variable contains: [var_value]")
		if(dir)
			switch(var_value)
				if(1)
					dir = "NORTH"
				if(2)
					dir = "SOUTH"
				if(4)
					dir = "EAST"
				if(8)
					dir = "WEST"
				if(5)
					dir = "NORTHEAST"
				if(6)
					dir = "SOUTHEAST"
				if(9)
					dir = "NORTHWEST"
				if(10)
					dir = "SOUTHWEST"
				else
					dir = null
			if(dir)
				to_chat(usr, "If a direction, direction is: [dir]")


		var/list/possible_classes = list("text","num","type","reference","mob reference","icon","file","list")
		if(LAZYLEN(stored_matrices))
			possible_classes += "matrix"
		if(admin_holder && admin_holder.marked_datums.len)
			possible_classes += "marked datum"
		possible_classes += "edit referenced object"
		possible_classes += "restore to default"

		class = tgui_input_list(usr, "What kind of variable?","Variable Type", possible_classes)
		if(!class)
			return

	var/original_name

	if (!istype(O, /atom))
		original_name = "\ref[O] ([O])"
	else
		original_name = O:name

	switch(class)

		if("list")
			mod_list(O.vars[variable])
			return

		if("restore to default")
			if(!O.vv_edit_var(variable, initial(O.vars[variable])))
				to_chat(usr, SPAN_WARNING("Your edit was rejected by the object."))
				return

		if("edit referenced object")
			return .(O.vars[variable])

		if("text")
			var/var_new = input("Enter new text:","Text",O.vars[variable]) as null|text
			if(isnull(var_new))
				return
			if(!O.vv_edit_var(variable, var_new))
				to_chat(usr, SPAN_WARNING("Your edit was rejected by the object."))
				return

		if("num")
			var/var_new =  tgui_input_real_number(src, "Enter new number:","Num", O.vars[variable])
			if(isnull(var_new))
				return
			if(!O.vv_edit_var(variable, var_new))
				to_chat(usr, SPAN_WARNING("Your edit was rejected by the object."))
				return

		if("type")
			var/var_new = tgui_input_list(usr, "Enter type:","Type", typesof(/obj,/mob,/area,/turf))
			if(isnull(var_new))
				return
			if(!O.vv_edit_var(variable, var_new))
				to_chat(usr, SPAN_WARNING("Your edit was rejected by the object."))
				return

		if("reference")
			var/var_new = input("Select reference:","Reference",O.vars[variable]) as null|mob|obj|turf|area in world
			if(isnull(var_new))
				return
			if(!O.vv_edit_var(variable, var_new))
				to_chat(usr, SPAN_WARNING("Your edit was rejected by the object."))
				return

		if("mob reference")
			var/var_new = input("Select reference:","Reference",O.vars[variable]) as null|mob in GLOB.mob_list
			if(isnull(var_new))
				return
			if(!O.vv_edit_var(variable, var_new))
				to_chat(usr, SPAN_WARNING("Your edit was rejected by the object."))
				return

		if("file")
			var/var_new = input("Pick file:","File",O.vars[variable]) as null|file
			if(isnull(var_new))
				return
			if(!O.vv_edit_var(variable, var_new))
				to_chat(usr, SPAN_WARNING("Your edit was rejected by the object."))
				return

		if("icon")
			var/var_new = input("Pick icon:","Icon",O.vars[variable]) as null|icon
			if(isnull(var_new))
				return
			if(!O.vv_edit_var(variable, var_new))
				to_chat(usr, SPAN_WARNING("Your edit was rejected by the object."))
				return

		if("matrix")
			var/matrix_name = tgui_input_list(usr, "Choose a matrix", "Matrix", (stored_matrices + "Cancel"))
			if(!matrix_name || matrix_name == "Cancel")
				return

			var/matrix/M = LAZYACCESS(stored_matrices, matrix_name)
			if(!M)
				return

			if(!O.vv_edit_var(variable, M))
				to_chat(usr, SPAN_WARNING("Your edit was rejected by the object."))
				return

			world.log << "### VarEdit by [key_name(src)]: [O.type] '[variable]': [var_value] => matrix \"[matrix_name]\" with columns ([M.a], [M.b], [M.c]), ([M.d], [M.e], [M.f])"
			message_staff("[key_name_admin(src)] modified [original_name]'s '[variable]': [var_value] => matrix \"[matrix_name]\" with columns ([M.a], [M.b], [M.c]), ([M.d], [M.e], [M.f])", 1)

		if("marked datum")
			var/datum/D = input_marked_datum(admin_holder.marked_datums)
			if(!O.vv_edit_var(variable, D))
				to_chat(usr, SPAN_WARNING("Your edit was rejected by the object."))
				return

	if(class != "matrix")
		world.log << "### VarEdit by [key_name(src)]: [O.type] '[variable]': [var_value] => [html_encode("[O.vars[variable]]")]"
		message_staff("[key_name_admin(src)] modified [original_name]'s '[variable]': [var_value] => [O.vars[variable]]", 1)
