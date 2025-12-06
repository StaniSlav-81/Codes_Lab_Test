Popis mého prvního projektu

Připravil jsem jednoduchou a snad efektivní aplikaci pro správu úkolů, která je dle zadání úkolu  napsaná v Bash a má interaktivním menu.

To-Do aplikace umožňuje správu seznamu úkolů přímo z příkazové řádky. Aplikace používá intuitivní číselné menu a ukládá všechny úkoly do textového souboru.

Hlavní funkce jsou:

Přidání úkolu - Vytvoření nového úkolu v seznamu
Zobrazení úkolů - Přehledný výpis všech úkolů s číslováním
Označení jako hotový - Označení dokončených úkolů symbolem [x]
Smazání úkolu - Odstranění úkolu ze seznamu
Vyhledávání - Rychlé nalezení úkolů podle klíčového slova
Statistiky - Přehled počtu všech, dokončených a nedokončených úkolů
Editace úkolu - Změna textu existujícího úkolu
Automatické ukládání - Všechny změny se ukládají do souboru todo.txt


Členění projektu:

todo-list/
├── todo.txt           # Hlavní skript s interaktivním menu
├── funkce.todo.sh     # Soubor s rozšiřujícími funkcemi
├── todo.txt           # Datový soubor s uloženými úkoly (vytvoří se automaticky)
└── README.md          # Dokumentace


Po spuštění se zobrazí interaktivní menu:

******************************
      To-Do aplikace
******************************
1/ Přidej úkol
2/ Zobraz úkoly
3/ Označ úkol jako hotový
4/ Smaž úkol
5/ Vyhledej úkol
6/ Zobraz statistiky
7/ Edituj úkol
8/ Ukonči akci
******************************
Příklady použití:

- Přidání úkolu:

Vybert možnost 1
Zadejt text úkolu
Úkol se uloží ve formátu [ ] Text úkolu
Označení jako dokončený:

Vyber možnost 3
Zadejte číslo úkolu
Úkol se označí jako [x] Text úkolu



- Vyhledávání:

Vyberte možnost 5
Zadejte hledaný výraz
Zobrazí se všechny odpovídající úkoly
Statistiky:

Vyberte možnost 6
Zobrazí se přehled:
Celkový počet úkolů
Počet dokončených úkolů
Počet nedokončených úkolů

Úkoly jsou ukládány do souboru todo.txt ve formátu:

[ ] Nedokončený úkol
[x] Dokončený úkol

Další zajímavisti:

Hlavní skript (todo.txt),
Interaktivní smyčka s menu,
Inicializace datového souboru,
Základní funkce pro správu úkolů,
Soubor funkcí (funkce.todo.sh),
search_tasks() - vyhledávání pomocí grep,
show_statistics() - výpočet statistik z datového souboru,
edit_task() - editace s uchováním stavu.

