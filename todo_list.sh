#!/bin/bash

# ==============================================================================
# TODO LIST - KNIHOVNA FUNKCÍ
# ==============================================================================
# Soubor obsahuje všechny funkce pro správu todo listu
# Autor: Student
# Datum: 2024
# ==============================================================================

# Globální proměnné
TODO_FILE="todo_list.csv"
BACKUP_DIR="backups"

# ------------------------------------------------------------------------------
# Funkce: init_todo_file
# Popis: Inicializuje CSV soubor pro ukládání úkolů, pokud neexistuje
# Vytvoří soubor s hlavičkou a nastaví správná přístupová práva (rw-r--r--)
# ------------------------------------------------------------------------------
init_todo_file() {
    if [[ ! -f "$TODO_FILE" ]]; then
        echo "ID;Úkol;Status;Datum vytvoření" > "$TODO_FILE"
        chmod 644 "$TODO_FILE"
        echo "✓ Inicializován nový TODO soubor: $TODO_FILE"
    fi
    
    # Vytvoření adresáře pro zálohy
    if [[ ! -d "$BACKUP_DIR" ]]; then
        mkdir -p "$BACKUP_DIR"
        chmod 755 "$BACKUP_DIR"
    fi
}

# ------------------------------------------------------------------------------
# Funkce: get_next_id
# Popis: Vrací další volné ID pro nový úkol
# Výstup: Číslo - další ID (INTEGER)
# ------------------------------------------------------------------------------
get_next_id() {
    local max_id=0
    
    # Přeskočí hlavičku a najde maximální ID
    while IFS=';' read -r id task status date; do
        if [[ "$id" =~ ^[0-9]+$ ]] && [[ $id -gt $max_id ]]; then
            max_id=$id
        fi
    done < <(tail -n +2 "$TODO_FILE")
    
    echo $((max_id + 1))
}

# ------------------------------------------------------------------------------
# Funkce: add_task
# Popis: Přidá nový úkol do TODO listu
# Parametry: $1 - text úkolu (STRING)
# Výstup: Zpráva o úspěchu/neúspěchu
# ------------------------------------------------------------------------------
add_task() {
    local task="$1"
    
    # Validace vstupu
    if [[ -z "$task" ]]; then
        echo "❌ Chyba: Úkol nemůže být prázdný!"
        return 1
    fi
    
    local new_id=$(get_next_id)
    local current_date=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Přidání úkolu do CSV
    echo "${new_id};${task};TODO;${current_date}" >> "$TODO_FILE"
    echo "✓ Úkol přidán s ID: $new_id"
}

# ------------------------------------------------------------------------------
# Funkce: list_tasks
# Popis: Zobrazí všechny úkoly v přehledném formátu
# Parametry: $1 - filtr statusu (volitelný: TODO/DONE/ALL)
# ------------------------------------------------------------------------------
list_tasks() {
    local filter="${1:-ALL}"
    local count=0
    
    echo ""
    echo "════════════════════════════════════════════════════════════════"
    echo "                     📋 TODO LIST"
    echo "════════════════════════════════════════════════════════════════"
    printf "%-5s %-40s %-10s %-20s\n" "ID" "Úkol" "Status" "Datum"
    echo "----------------------------------------------------------------"
    
    # Čtení a zobrazení úkolů
    while IFS=';' read -r id task status date; do
        # Přeskočí hlavičku
        if [[ "$id" == "ID" ]]; then
            continue
        fi
        
        # Filtrování podle statusu
        if [[ "$filter" == "ALL" ]] || [[ "$status" == "$filter" ]]; then
            # Barevné označení podle statusu
            if [[ "$status" == "DONE" ]]; then
                printf "%-5s %-40s \033[32m%-10s\033[0m %-20s\n" "$id" "$task" "✓ $status" "$date"
            else
                printf "%-5s %-40s \033[33m%-10s\033[0m %-20s\n" "$id" "$task" "○ $status" "$date"
            fi
            ((count++))
        fi
    done < "$TODO_FILE"
    
    echo "----------------------------------------------------------------"
    echo "Celkem úkolů: $count"
    echo ""
}

# ------------------------------------------------------------------------------
# Funkce: mark_done
# Popis: Označí úkol jako hotový (změní status na DONE)
# Parametry: $1 - ID úkolu (INTEGER)
# Výstup: Zpráva o úspěchu/neúspěchu
# ------------------------------------------------------------------------------
mark_done() {
    local task_id="$1"
    local temp_file="${TODO_FILE}.tmp"
    local found=0
    
    # Validace ID
    if [[ ! "$task_id" =~ ^[0-9]+$ ]]; then
        echo "❌ Chyba: ID musí být číslo!"
        return 1
    fi
    
    # Vytvoření dočasného souboru s aktualizovaným statusem
    while IFS=';' read -r id task status date; do
        if [[ "$id" == "$task_id" ]]; then
            echo "${id};${task};DONE;${date}" >> "$temp_file"
            found=1
        else
            echo "${id};${task};${status};${date}" >> "$temp_file"
        fi
    done < "$TODO_FILE"
    
    # Přepsání původního souboru
    if [[ $found -eq 1 ]]; then
        mv "$temp_file" "$TODO_FILE"
        chmod 644 "$TODO_FILE"
        echo "✓ Úkol ID $task_id označen jako hotový!"
    else
        rm -f "$temp_file"
        echo "❌ Úkol s ID $task_id nenalezen!"
        return 1
    fi
}

# ------------------------------------------------------------------------------
# Funkce: delete_task
# Popis: Smaže úkol z TODO listu
# Parametry: $1 - ID úkolu (INTEGER)
# Výstup: Zpráva o úspěchu/neúspěchu
# ------------------------------------------------------------------------------
delete_task() {
    local task_id="$1"
    local temp_file="${TODO_FILE}.tmp"
    local found=0
    
    # Validace ID
    if [[ ! "$task_id" =~ ^[0-9]+$ ]]; then
        echo "❌ Chyba: ID musí být číslo!"
        return 1
    fi
    
    # Vytvoření nového souboru bez mazaného úkolu
    while IFS=';' read -r id task status date; do
        if [[ "$id" != "$task_id" ]]; then
            echo "${id};${task};${status};${date}" >> "$temp_file"
        else
            found=1
        fi
    done < "$TODO_FILE"
    
    # Přepsání původního souboru
    if [[ $found -eq 1 ]]; then
        mv "$temp_file" "$TODO_FILE"
        chmod 644 "$TODO_FILE"
        echo "✓ Úkol ID $task_id byl smazán!"
    else
        rm -f "$temp_file"
        echo "❌ Úkol s ID $task_id nenalezen!"
        return 1
    fi
}

# ------------------------------------------------------------------------------
# Funkce: backup_tasks
# Popis: Vytvoří zálohu aktuálního TODO listu
# Výstup: Zpráva o vytvoření zálohy
# ------------------------------------------------------------------------------
backup_tasks() {
    local backup_name="${BACKUP_DIR}/todo_backup_$(date '+%Y%m%d_%H%M%S').csv"
    
    if [[ -f "$TODO_FILE" ]]; then
        cp "$TODO_FILE" "$backup_name"
        chmod 644 "$backup_name"
        echo "✓ Záloha vytvořena: $backup_name"
    else
        echo "❌ Nelze vytvořit zálohu - TODO soubor neexistuje!"
        return 1
    fi
}

# ------------------------------------------------------------------------------
# Funkce: search_tasks
# Popis: Vyhledá úkoly obsahující zadaný text
# Parametry: $1 - hledaný text (STRING)
# ------------------------------------------------------------------------------
search_tasks() {
    local search_term="$1"
    local count=0
    
    echo ""
    echo "🔍 Výsledky vyhledávání pro: '$search_term'"
    echo "----------------------------------------------------------------"
    
    while IFS=';' read -r id task status date; do
        if [[ "$id" == "ID" ]]; then
            continue
        fi
        
        # Vyhledávání (case-insensitive)
        if [[ "${task,,}" == *"${search_term,,}"* ]]; then
            printf "%-5s %-40s %-10s %-20s\n" "$id" "$task" "$status" "$date"
            ((count++))
        fi
    done < "$TODO_FILE"
    
    echo "----------------------------------------------------------------"
    echo "Nalezeno úkolů: $count"
    echo ""
}
