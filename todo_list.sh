#!/bin/bash
#Moje první To-Do aplikace v Bashi :-)

# Soubor se seznamem úkolů
TODO_FILE="todo.txt"

# Funkce: inicializace souboru - ověření a vytvoření
init_file() {
    if [ ! -f "$TODO_FILE" ]; then
        touch "$TODO_FILE"
        echo "Soubor $TODO_FILE byl vytvořen."
    fi
}

# NEJPRVE inicializuj soubor
init_file

# Načtení funkcí z externího souboru
source ./funkce.todo.sh

# Funkce: zobrazení menu
show_menu() {
    echo "******************************"
    echo "      To-Do aplikace"
    echo "******************************"
    echo "1/ Přidej úkol"
    echo "2/ Zobraz úkoly"
    echo "3/ Označ úkol jako hotový"
    echo "4/ Smaž úkol"
    echo "5/ Vyhledej úkol"
    echo "6/ Zobraz statistiky"
    echo "7/ Edituj úkol"
    echo "8/ Ukonči akci"
    echo "******************************"
}

# Funkce: přidání úkolu
add_task() {
    read -p "Zadej nový úkol: " task
    echo "[ ] $task" >> "$TODO_FILE"
    echo "Úkol přidán!"
}

# Funkce: zobrazení úkolů
view_tasks() {
    if [ ! -s "$TODO_FILE" ]; then
        echo "Seznam úkolů je prázdný."
        return
    fi
    echo "Zobraz úkoly:"
    nl -w2 -s'. ' "$TODO_FILE"
}

# Funkce: označení úkolu jako dokončeného
mark_task() {
    view_tasks
    if [ ! -s "$TODO_FILE" ]; then
        return
    fi
    read -p "Zadej číslo úkolu k označení: " num
    
    # Ověř, že číslo je platné
    total_lines=$(wc -l < "$TODO_FILE")
    if [ "$num" -lt 1 ] || [ "$num" -gt "$total_lines" ]; then
        echo "Neplatné číslo úkolu!"
        return
    fi
    
    sed -i "${num}s/\\[ \\]/[x]/" "$TODO_FILE"
    echo "Úkol označen jako dokončený!"
}

# Funkce: smazání úkolu
delete_task() {
    view_tasks
    if [ ! -s "$TODO_FILE" ]; then
        return
    fi
    read -p "Zadej číslo úkolu ke smazání: " num
    
    # Ověř, že číslo je platné
    total_lines=$(wc -l < "$TODO_FILE")
    if [ "$num" -lt 1 ] || [ "$num" -gt "$total_lines" ]; then
        echo "Neplatné číslo úkolu!"
        return
    fi
    
    sed -i "${num}d" "$TODO_FILE"
    echo "Úkol vymazán!"
}

# Hlavní smyčka
while true; do
    show_menu
    read -p "Vyberte jednu z možností: " choice
    case $choice in
        1) add_task ;;
        2) view_tasks ;;
        3) mark_task ;;
        4) delete_task ;;
        5) search_tasks ;;
        6) show_statistics ;;
        7) edit_task ;;
        8) echo "Ukončuji program."; break ;;
        *) echo "Neplatná volba, zkuste znovu." ;;
    esac
done
