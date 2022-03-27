import os
import re

from colored import fg, bg, attr

cache = {}
ignores = {
	"_manifest.ymf": True,
}

for subdir, dirs, files in os.walk("./"):
	if re.match(".+\\\stream\\\.+", subdir):
		for file_name in files:
			if file_name not in ignores and re.match(".+\\..+", file_name) and not re.match(".+\\.(lua|meta|png|afphoto|psd)", file_name):
				if file_name in cache:
					print(f"\n{bg('black')}{fg('white')}Conflicting file '{bg('red_3a')}{file_name}{bg('black')}' found")
					print(f"\tIn:\t{subdir}")
					print(f"\tWith:\t{cache[file_name]}")
				else:
					cache[file_name] = subdir