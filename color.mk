#!make
help:
	@echo This is help target in color.mk.
	@echo Including color.mk provides the function to change colors.
	@echo -n $$\(call red,hello red text\) =\>\\t
	$(call red,hello red text)
	@echo -n $$\(call blue,hello blue text\) =\>\\t
	$(call blue,hello blue text)
	@echo -n $$\(call green,hello green text\) =\>\\t
	$(call green,hello green text)
	@echo -n $$\(call white,hello white text\) =\>\\t
	$(call white,hello white text)
	@echo -n $$\(call magenta,hello magenta text\) =\>\\t
	$(call magenta,hello magenta text)
	@echo -n $$\(call cyan,hello cyan text\) =\>\\t
	$(call cyan,hello cyan text)
	@echo -n $$\(call yellow,hello yellow text\) =\>\\t
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

