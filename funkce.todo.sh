#!/bin/bash
# Pomocné funkce pro To-Do aplikaci

# Funkce: která bude vyhledávat úkoly
search_tasks() {
    read -p "Zadej hledaný výraz: " search_term
    echo "Nalezené úkoly:"
    
    result=$(grep -n "$search_term" "$TODO_FILE")
    
    if [ -z "$result" ]; then
        echo "Žádné úkoly nenalezeny."
    else
        echo "$result" | nl -w2 -s'. '
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
    echo "Hotové úkoly:       $completed"
    echo "Nedokončené úkoly:  $pending"
    echo "******************************"
}

# Funkce: úprava úkolu
edit_task() {
    view_tasks
    if [ ! -s "$TODO_FILE" ]; then
        return
    fi
    read -p "Zadej číslo úkolu k editaci: " num
    
    # Ověř, že číslo je platné
    total_lines=$(wc -l < "$TODO_FILE")
    if [ "$num" -lt 1 ] || [ "$num" -gt "$total_lines" ]; then
        echo "Neplatné číslo úkolu!"
        return
    fi
    
    read -p "Zadej nový text úkolu: " new_task
    
    # Zjisti a prověř aktuální stav (dokončený/nedokončený)
    status=$(sed -n "${num}p" "$TODO_FILE" | grep -o "\\[.\\]")
    
    # Pokud status není nalezen, použij výchozí [ ]
    if [ -z "$status" ]; then
        status="[ ]"
    fi
    
    sed -i "${num}s/.*/$status $new_task/" "$TODO_FILE"
    echo "Úkol upraven!"
}
