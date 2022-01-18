Ciclo for 4 in cui scanf STR e inserisco in N la sua strlen.<br>
Segue uno scanf per l'indice i della stringa da processare (passo alla funzione STR[i],N[i]);<br>
la funzione fa un ciclo for della strlen della str passata e se vede che un elemento di str[] è >= 58 (cioè non è un numero (i numeri in ascii vanno da 47 a 57); 
<br>se si rompe il ciclo e torna l'indice i precedente (l'ultimo che non era >=58). 

<br><br>Se nessuno soddisfa >=58 ritorna l'indice i a fine for, cioè i=strlen(d).<br>Infine questo indice ritornato è A, e stampo il msg3 che ha 2 argomenti : questo indice tornato dalla funzione, A, è l'indice acquisito con msg2 per scegliere STR[i] e N[i] da passare
