## Naming convention for Git :
- adding a feature or a file -> "[ADD] {feature or file}"
- removing a feature or a file -> "[DEL] {feature or file}"
- bug fix -> "[FIX] {bug} in {feature}"
- moving file -> "> [MOV] {file} from {folder} to {folder}"
- refactorisation -> "> [REF] {feature or file}"
- other -> "[OTH] {explanation}"

## Naming convention for the code :
> Following the recommandation of Godot : https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html
- Class = PascalCase
- fonction = snake_case
- variable = snake_case
- CONSTANTE = SCREAMING_SNAKE_CASE

## Naming convention for nodes in the tree of scene :
> Following the recommandation of Godot : https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html
- All : PascalCase

## Naming convention for files system :
- .gd files : snake_case
- .tscn files : snake_case
- .md files : PascalCase (except README file)
- assets files (images, fonts, etc) : snake_case
- directories : PascalCase

## Folders architecture
```
📦Game/
 ┣ 📂Assets/
 ┃ ┣ 📂Images/
 ┃ ┃ ┣ 📂Sprites/
 ┃ ┃ ┣ 📂Icons/
 ┃ ┃ ┗ 📂Environment/
 ┃ ┃
 ┃ ┗ 📂Sounds/
 ┃
 ┣ 📂GlobalClasses/
 ┃ ┗ 📜script.gd
 ┃
 ┣ 📂Scenes/
 ┃ ┣ 📂Components/
 ┃ ┃ ┣ 📂ComponentName
 ┃ ┃ ┃ ┣ 📜component_name.gd
 ┃ ┃ ┃ ┗ 📜component_name.tscn
 ┃ ┃ ┗ 📂...
 ┃ ┃
 ┃ ┗ 📂Screens/
 ┃   ┣ 📂ScreenName/
 ┃   ┃ ┣ 📜screen_name.gd
 ┃   ┃ ┗ 📜screen_name.tscn
 ┃   ┗ 📂...
 ┃
 ┗ 📂Themes/
   ┗ 📜theme_name.tres
```