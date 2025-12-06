#!/bin/bash

# Funkce: která bude vyhledávat úkoly
search_tasks() {
    read -p "Zadej hledaný výraz: " search_term
    echo "Nalezené úkoly:"
    grep -n "$search_term" "$TODO_FILE" | nl -w2 -s'. '
    
    if [ $? -ne 0 ]; then
        echo "Žádné úkoly nenalezeny."
    fi
}

# Funkce: ukaž mi statistiky
show_statistics() {
    if [ ! -s "$TODO_FILE" ]; then
        echo "Seznam úkolů je prázdný."
        return
    fi
    
    total=$(wc -l < "$TODO_FILE")
    completed=$(grep -c "\\[x\\]" "$TODO_FILE")
    pending=$((total - completed))
    
    echo "******************************"
    echo "       STATISTIKY"
    echo "******************************"
    echo "Všechny úkoly:      $total"
    echo "Hotové úkoly:         $completed"
    echo "Nedokončené úkoly:       $pending"
    echo "******************************"
}

# Funkce: úprava úkolu
edit_task() {
    view_tasks
    read -p "Zadej číslo úkolu k editaci: " num
    read -p "Zadej nový text úkolu: " new_task
    
    # Zjisti prověř aktuální stav (dokončený/nedokončený)
    status=$(sed -n "${num}p" "$TODO_FILE" | grep -o "\\[.\\]")
    
    sed -i "${num}s/.*/$status $new_task/" "$TODO_FILE"
    echo "Úkol upraven!"
}
