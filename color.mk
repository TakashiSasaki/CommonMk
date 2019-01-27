ifndef color-included
color-included=1
.PHONY: color-default
color-default:
	@echo This is help target in color.mk.
	@echo Including color.mk provides the function to change colors.
	@echo -e -n "\$$(call red,hello red text)\t\t=>\t"
	$(call red,hello red text)
	@echo -e -n "\$$(call blue,hello blue text)\t\t=>\t"
	$(call blue,hello blue text)
	@echo -e -n "\$$(call green,hello green text)\t\t=>\t"
	$(call green,hello green text)
	@echo -e -n "\$$(call white,hello white text)\t\t=>\t"
	$(call white,hello white text)
	@echo -e -n "\$$(call magenta,hello magenta text)\t=>\t"
	$(call magenta,hello magenta text)
	@echo -e -n "\$$(call cyan,hello cyan text)\t\t=>\t"
	$(call cyan,hello cyan text)
	@echo -e -n "\$$(call yellow,hello yellow text)\t=>\t"
	$(call yellow,hello yellow text)
	

define resetColor
	@bash -c 'echo -e "\e[m"'
endef

define black
	@bash -c 'echo -e "\e[30m"$1$2$3$4$5$6$7$8$9"\e[m"'
endef

define red
	@bash -c 'echo -e "\e[31m"$1$2$3$4$5$6$7$8$9"\e[m"'
endef

define green
	@bash -c 'echo -e "\e[32m"$1$2$3$4$5$6$7$8$9"\e[m"'
endef

define yellow
	@bash -c 'echo -e "\e[33m"$1$2$3$4$5$6$7$8$9"\e[m"'
endef

define blue
	@bash -c 'echo -e "\e[34m"$1$2$3$4$5$6$7$8$9"\e[m"'
endef

define magenta
	@bash -c 'echo -e "\e[35m"$1$2$3$4$5$6$7$8$9"\e[m"'
endef

define cyan
	@bash -c 'echo -e "\e[36m"$1$2$3$4$5$6$7$8$9"\e[m"'
endef

define white
	@bash -c 'echo -e "\e[37m"$1$2$3$4$5$6$7$8$9"\e[m"'
endef

endif # color-included
