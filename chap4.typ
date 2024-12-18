#import "template.typ": *

#show: book-template.with(
  chapter: 4,
  version: "1.0"
)

= Estimators

Erneut befinden wir uns an dem Punkt, wo wir die genaue Verteilung zu etwas nicht
wissen. Bzw. wir wissen ggf. was für eine Art von Verteilung haben, wissen dann
aber nicht mit welchen Parametern diese Verteilung aufgebaut ist. Dieses Thema
beschäftigt sich eben genau mit der Bestimmung solcher Parameter.

Aber erst einmal was sind denn überhaupt diese Parameter? \
Visuell sind die Parameter einfach die Werte, die man der Verteilung übergibt. 
Bei $cal(N)(mu, sigma^2)$ sind z.B. $mu$ und $sigma^2$ die Parameter. Diese
ganzen Parameter fassen wir dann in einen Vektor $theta$ zusammen:
$theta = (mu, sigma^2)^T$. Nun einmal für alle uns bekannte Verteilungen:
#notation-table(table(
  columns: (1fr,1fr),
  table.header([Verteilung], [Parameter]),
  $"Ber"(p)$, $theta=p$,
  $"Bin"(n,p)$, $theta=(n,p)^T$,
  $"Poi"(lambda)$, $theta=lambda$,
  $"Uniform"(a,b)$, $theta=(a,b)^T$,
  $cal(N)(mu, sigma^2)$, $theta=(mu, sigma^2)^T$
))

#note[Jan, genauso wie viele andere auch, verwenden oft auch eckige Klammern
um den Vektor darzustellen. Um das ganze allerdings einheitlich mit Mathe I
zu machen wurden hier Runde Klammern gewählt.]

Um diese Parameter zu schätzen gibt es nun zwei Arten von Estimators:

#grid(columns: (1fr, 1fr), column-gutter: 2em)[
  #definition("Point Estimators")[
    *Point Estimators* nutzen gesammelte Daten und rechnen damit einen
    einzelnen geschätzten Wert für einen Parameter aus. Dieser ist dann die
    beste Schätzung.
  ]
][
  #definition("Interval Estimators")[
    *Interval Estimators* bestimmen im Kontrast dazu ein Intervall an 
    möglichen Werten für einen Parameter. Typischerweise wird dieses Intervall
    durch eine Unter-/Obergrenze angegeben.
  ]
]

// Zwei Folien geskippt, sehe aber für die keine relevanz, da wenig Inhalt.

== Maximum Likelihood Estimation

Hierfür brauchen wir zuerst unsere Beispieldaten $cal(D) = {x_i}_(i=1)^n$

Außerdem brauchen wir noch den Begriff der _Likelihood_ $L(theta)=p(D | theta)$. 
Diese gibt  die Wsk. an, dass Daten $cal(D)$ mit den Parametern $theta$ 
generiert wurden.

Nun ist unser Ziel hier diese _Likelihood_ zu maximieren, also
$
  arg max_theta L(theta) = p(cal(D) | theta)
$
zu bestimmen.

Dafür müssen die Daten allerdings *unabhängig* und *gleichmäßig verteilt* 
(i.i.d.) sein,heißt:
- unabhängig: $P(X_1 <= alpha, X_2 <= beta)=P(X_1 <= alpha) P(X_2 <= beta) quad
  forall alpha, beta in bb(R)$
- gleichmäßig verteilt: $P(X_1 <= alpha) = P(X_2 <= beta) quad forall alpha, 
  beta in bb(R)$

Aus dieser Bedingung erhalten wir dann:
$
  L(theta) = p(cal(D) | theta) 
  = p(x_1,x_2,...,x_n | theta) 
  // todo iid
  =^"i.i.d." p(x_1 | theta) p(x_2 | theta) ... p(x_n | theta) 
  = product_(k=1)^n p(x_k | theta)
$
Für das Ergebnis der MLE schreiben wir auch $hat(theta)_"ML"$. Das wichtige
hierbei ist das dies erst einmal wieder als Zufallsvariable ansehbar ist. Uns
interessiert dabei dann der Erwartungswert und die Varianz.

*Log Likelihood*: \
Da es meist einfacher zu berechnen ist, kann man auch den Logarithmus der
Likelihood maximieren. Dies ist möglich, da der Logarithmus soweit ordentlich
runterskaliert.

$
  log L(theta) = log p(cal(D) | theta) = log product_(k=1)^n p(x_k | theta) = 
  sum_(k=1)^n log p(x_k | theta)
$

Das Maximum einer Summe zu bestimmen ist nun deutlich einfacher, da z.B. auch
ableiten deutlich einfacher wird. Dazu ist es auch numerisch stabiler,
da Werte nahe 0 im Logarithmus wieder etwas größer werden, wodurch wir die
floating point precision unserer Rechner nicht ankratzen.

== Bayesian Estimation

Was man nun beobachten kann, ist das in MLE die Parameter $theta$ als feste
Werte angesehen werden, weswegen es sich dabei auch um Point Estimators handelt.
Nun betrachten wir aber mal einen anderen Fall, bei dem wir unsere Parameter
$theta$ als eine Zufallsvariable betrachten. Dabei kann dann erneut ein fester
Wert entstehen, der am wahrscheinlichsten angenommen wird, es kann aber eben
auch ein Bereich rauskommen -- also eine density estimation.

// ggf. noch etwas mehr auf die Unterschiede zwischen Frequentist und Bayesian
// eingehen? siehe Folie 23

Bevor wir weiter in die Bayesion Estimation eintauchen gilt es noch zwei
Begriffsklärungen zu machen:
/ Prior: Bezeichnet die Vermutung über die Parameter, bevor wir jegliche Daten
  beobachtet haben $p(theta)$
/ Posterior: Der Posterior bezeichnet nun Widerum wie gut ein Prior gewählt
  wurde bzw. wie unsicher wir uns in unserem Prior sind, nachdem wir neue
  Daten beobachtet haben $p(theta | D)$

Laut Bayes Theorem können wir diesen Posterior eben wie folgt ausrechnen:
$
  p(theta | D) = (p(D | theta) p(theta))/(p(D))
$

Durch gewisse Umformungen erhalten wir dazu noch folgende Formel zur Bestimmung
der Evidence $p(D)$:
$
  p(D) = integral p(D|theta)p(theta) dif theta 
  = integral L(theta) p(theta) dif theta
$

// Folie 27-29 sind sehr random. Laut Sprechstunde kann x hier beliebig sein.
// Ggf. später noch einbauen, gerade noch nicht so relevant.
// Siehe auch Bishops Buch S. 31 Formel 1.68

// MLE betrachtet Parameter fix, Bayesian als Zufallsvariable

Häufig schreibt man zum Posterior auch noch folgendes:
$ "Posterior" prop "Prior" times "Likelihood" div "Evidence" $
#note[$prop$ heißt einfach proportianal, also $A prop B <=> A = k B$]

Wirklich etwas damit anfangen können wir nicht. Aber vielleicht hat es ja einen
nutzen #emoji.person.shrug

#note[Bayesian Estimation wurde hier nur sehr gebrochen und wahrscheinlich
unvollständig erklärt. Falls hier jemand noch was gutes zum ergänzen hat gerne
melden oder selbst machen und dann PR.]

Zuletzt noch die Begriffsklärung *Conjugate Priors*: Dies bedeutet lediglich,
dass die Verteilungen des Prior und des Posterior zur selben Familie gehören.
Also z.B. beide eine Normalverteilung haben.

= Maximum A-Posteriori

Jetzt haben wir aber nur darüber geredet, wie wir mit dem Posterior rechnen
können. Aber wie können wir nun überhaupt ordentlich einen Wert -- oder etwas
in die Richtung -- bestimmen? Dafür ist eben die Maximum A-Posteriori (MAP) 
Estimation da.

Also wie macht man das nun? Jeder der hier große bedenken hat wird gleich mit
großer trivialität enttäuscht:
$
  hat(theta)_"MAP" &= arg max_theta p(theta | D) \
  &= arg max_theta (p(D | theta) p(theta)) / p(D) \
  &= arg max_theta p(D | theta) p(theta) \
  &= arg max_theta log p(D | theta) + log p(theta) \
  (&= arg max_theta sum_(k=1)^n log p(x_k | theta) + p(theta))
$

Man beachte, dass wir den Nenner $p(D)$ einfach wegstreichen. Ich vermute mal,
dass dies den Grund hat, dass $p(D)$ unabhängig von $theta$ ist und somit über
$max$ ein konstanter, ignorierbarer Faktor ist.

Nun wird man feststellen, dass diese Formel recht ähnlich zur MLE aussieht.
Genauer kann MLE eine Form von MAP betrachtet werden, wobei allerdings der
Prior $p(theta)$ immer einen konstanten Wert annimmt. Also
$
  p(theta) = "const" => hat(theta)_"MAP" = arg max_theta log p(D | theta)
  + "const" eq.est hat(theta)_"ML"
$

= Supervised learning problems

Nun kommen wir ggf. mal etwas mehr in Richtung KI -- wenn auch nur sehr 
mathematisch.

Dafür können wir erstmal einen Grundsatz für KI aufstellen. In der
uns bisher bekannten Mathematik und Informatik ist es hauptsächlich so:
wir haben Eingabedaten $I$ und einen Algorithmus bzw. eine Funktion $f$ und
bestimmen damit die Ausgabedaten $O$. Nun kann es aber eben sein, dass diese
Funktion $f$ nicht so einfach realisierbar ist oder wir erst gar keine
Anhaltspunkte zur Realisierung haben. Dann haben wir eher den Fall, dass wir
bereits Beispiele an Input/Output Daten haben, aber keinen Anhaltspunkt, wie man
diese ordentlich bestimmt. Entsprechend gilt es nun also unsere Funktion $f$ zu
bestimmen.

#note[Dieser Absatz ist so nicht auf Jans Folien zu finden, sondern eher ein
eigener Abschweif. Über die Richtigkeit -- auch wenn das geschriebene eher
Philosophisch ist -- kann ich keine Garantien machen.]

Wir befinden uns hier bei supervised (de: beobachteten) Problemen. Das heißt
konkret, dass wir die Datenbereiche bereits kennen bzw. diese gekennzeichnet
(engl. labeled) sind, und nur unsere Funktion $f: I -> O$ bestimmen wollen.

Hier gibt es nun noch die folgende Unterscheidung:
/ Regression: Hierbei ist der Ausgabebereich $O$ stetig, besteht also aus
  unendlich durchgehenden Werten
/ Classification: Hierbei ist $O$ diskret, besteht also nur aus festen Werten

Jeweils ein Beispiel:
- Den genauen Notendurchschnitt für die Promi Klausur vorhersagen. Dies ist ein
  Regression Problem, da es (zumindest bis zu einem gewissen Grad) eine
  beliebige Zahl im Intervall $[1,5]$ sein kann.
- Die Anzahl der 1.0er der Promi Klausur zu bestimmen. Dies hingegen ist ein
  Classification Problem, da es nicht möglich ist eine 1.0 zu schreiben. \
  Ein passenderes Beispiel ist hier jedoch sowas wie die Einordnung bzw.
  Klassifizierung einer Mail als Spam oder nicht Spam. 

== Regression aka. Curve Fitting

Nun einmal verschiedene Methoden um bei Regression Problemen anhand von Daten 
eben solche Funktionen $f$ zu bestimmen. 

#dangerous[Dazu kommt im folgenden häufig Parameter $w$ vor. Diese kann man -- 
in Bezug auf KI -- auch als weights bezeichnen.]

=== Least Squares Linear Regression

Zuerst gucken wir uns die Least Squares Linear Regression an. Wie man ggf.
am Namen schon erkennen kann bekommen wir hier eine lineare Abschätzung.
Also eben eine Gerade $y = m x + b$ bzw. Ausgleichsgerade.

Wir haben nun folgende Daten beobachtet:
- Eingaben $cal(X) = {x_1,...,x_n | x_i in bb(R)^d}$
- Ergebnisse $cal(Y) = {y_1,...,y_n | y_i in bb(R)^k}$
#note[Im allgemeinen sind $d$ und $k$ hier beliebig. Im folgenden betrachten
wir nun den Fall $k=1$.]

Diese Daten ordnen wir in Paare $(x_i, y_i)$ für $i in {1,...,n}$

Dazu nehmen wir noch:
- Die uns unbekannten, zu bestimmenden Parameter $w$ in Form eines Vektor mit
  $d$ Elementen. Im Falle der Geradengleichung ist dies quasi unsere Steigung
  $m$.
- Und Skalar $epsilon_0$, dass für eine uns unbekannte Zufallsvariablen steht
  und zur Fehlerminimierung dient. Was analog das $b$ der Gerade ist.
  // Eigentlich n viele epsilon?

Dazu stellen wir dann für alle Paare $(x_i, y_i)$ folgende Gleichung auf:
$
  angle.l x_i | w angle.r + epsilon_0 = y_i
$
#note[$angle.l dot | dot angle.r$ bezeichnet das Skalarprodukt]

Nun wollen wir all diese Gleichungen nach $w$ auflösen.
+ #[
  Dafür stellen wir zuerst zwei Vektoren auf, die unsere Gleichung homogen
  machen:
  $
    hat(x)_i = vec(x_i, 1) quad hat(w) = vec(w, epsilon_0)
  $
]
+ #[
  Es ergibt sich:
  $
    angle.l hat(x)_i | hat(w) angle.r = y_i
  $
]
+ #[
  Zuletzt fassen wir alle unsere Gleichungen in eine große Gleichung zusammen.
  Dafür definieren wir zuerst die Matrix $hat(X)$ und den Vektor $y$:
  $
    hat(X) = (hat(x)_1, ..., hat(x)_n) quad y = (y_1, ..., y_n)^T
  $
  $hat(X)$ hat also $hat(x)_1$ bis $hat(x)_n$ als Spalten.
  
  Damit ergibt sich:
  $
    hat(X)^T hat(w) = y
  $
  Alternativ hätten wir auch $hat(X)$ Zeilenweise definieren können, dann
  müssten wir hier nicht transponieren.
]
+ #[
  Nun zum Herzstück dieser Methode: Wir wollen nun unsere Parameter $w$ so 
  wählen, dass die Differenz zwischen unseren Eingabepunkten $hat(X)^T w$ und
  den Ergebnissen $y$ zum Quadrat hin recht niedrig ausfällt.
  Also:
  $
    hat(w) = arg min_w norm(hat(X)^T w - y)_2^2 
    = arg min_w sum_(i=1)^n (angle.l hat(x)_i | w angle.r - y_i)^2 
  $
  Dies gelingt eben durch Bestimmung der Extrempunkte des Gradienten über $w$:
  $
    gradient_w norm(hat(X)^T w - y)_2^2 = 0
  $
  // TODO: Genauer auf Formel eingehen
  Aber allgemein erhält man:
  $
    hat(X)^T hat(w) = y <=> hat(X) hat(X)^T hat(w) = hat(X) y <=>
    hat(w) = (hat(X) hat(X)^T)^(-1) hat(X) y
  $
]

Aber hieraus erhält man eben nur lineare Abschätzungen.

=== Polynomial Regression

Ohne jetzt auf genaue Lösungsstrategien einzugehen wollen wir uns trotzdem mal
den Ansatz angucken. Wir stellen nun folgende Gleichung auf:
$
  y(x,w) = sum_(i=1)^M w_i x^i
$
Dies ist eben einfach die Gleichung eines Polynom $M$-ten Grades. Dazu bleibt 
wie gesagt die Herleitung von $w$ offen.

Man beachte, dass für zu große $M$ dieser Ansatz zu overfitting, also einer
zu sehr an den Datenpunkten orientierten Funktion, die nichtmehr direkt ein
Mittel aus den Punkten zieht sondern nur noch die Punkte selbst einbezieht.

=== MLE Regression bzw. Probabilistic Regression

#note[Im folgenden verwenden wir nun die Schreibweise $p(x;theta)$, wobei
das $;$ als Trennung zwischen "Eingabe" in die Wsk. Funktion und den Parametern
der Funktion gilt. An sich könnte man es, wie wir es auch davor gemacht haben,
wieder mit einem $|$ schreiben. Dies kann aber eben auch sehr unübersichtlich
werden. Bsp.: $p(x|y; a,b)$ steht für $p((x|y) | a,b)$.]

// Auf Folie 60 scheint Jan ein wenig zu haluzinieren.

#note[Der folgende Abschnitt orientiert sich etwas stärker an der Erklärung
von Bishop (Seite 28f.)]

Nun befinden wir uns wieder am Punkt wo wir folgendes haben:
- Eingabedaten $X = (x_1,...,x_n) in bb(R)^(d times n)$
- Ergebnisse $Y = (y_1,...,y_n)^T in bb(R)^n$
// Warum soll das ganze Matrix/Vektor sein?

Nun ist es ja unser Ziel eine Grundlegende Struktur für die Funktion $f$ zu 
finden. Dazu wollen wir hier für beliebige $x$ einen entsprechenden Zielwert 
$f(x)=t$ bestimmen. Die Idee hier ist nun, mittels einer Gaußverteilung die Wsk.
zu  bestimmen, dass der Wert $t$ angenomen wird.

Diese Gaußverteilung hat den Mittelwert den Mittelwert $y(x,w)$ ($y$ aus 
Polynomial Regression, Grad $M$ scheint erstmal nicht so relevant zu sein) und 
die Standardabweichung eines gegebenen $sigma$ hat.

Setzen wir das ganze zusammen erhalten wir: 
$
  p(t|x; w, sigma) = cal(N) (t; y(x,w), sigma^2)
$

Nun haben wir also noch die unbekannten Parameter $w$, $sigma$. Diese können
wir nun mit den uns bekannten Daten und MLE ausrechnen:

$
  p(Y | X; w, sigma) = product_(i=1)^n p(y_i | x_i; w, sigma)
  = product_(i=1)^n cal(N) (y_i; y(x_i, w), sigma^2)
$

Das können wir nun mittels Log Likelihood simplifizieren:
$
  log p(Y | X; w, sigma) &= sum_(i=1)^n log cal(N) (y_i; y(x_n, w), sigma^2) \
  &= sum_(i=1)^n (log (1/sqrt(2 pi sigma^2)) - 1/(2 sigma^2) (y_i-y(x_i,w))^2) \
  &= -n log (sqrt(2 pi sigma^2))
  - 1/(2 sigma^2) sum_(i=1)^n (y_i - y(x_i,w))^2
$

Nun kann man eben erneut den Gradient davon bilden und damit die Extremwerte
berechnen.

Zur Hilfe nehmen wir noch die Funktion $phi_M (x)=(1,x,x^2,...,x^M)^T$. Damit
ergibt sich auch $y(x,w)=angle.l phi_M (x) | w angle.r$

$
  gradient_w log p(Y | X; w, sigma) &= 0 &<=> \
  - 1/(sigma^2) sum_(i=1)^n (y_i - y(x_i, w)) phi_M (x_i) &= 0 &<=> \
  sum_(i=1)^n (y_i - y(x_i, w)) phi_M (x_i) &= 0 &<=> \
  sum_(i=1)^n y_i phi_M (x_i) &= sum_(i=1)^n y(x_i, w) phi_M (x_i) & \
$

Nun definieren wir uns
$
  Phi = mat(|, , |; phi_M (x_1), dots.c, phi_M (x_n); |, , |)
$
und damit können wir dann obige Gleichung weiter runterbrechen:
$
  sum_(i=1)^n y_i phi_M (x_i) &= sum_(i=1)^n y(x_i, w) phi_M (x_i) &<=> \
  Phi Y &= sum_(i=1)^n y(x_i, w) phi_M (x_i) &<=> \
  Phi Y &= sum_(i=1)^n angle.l phi_M (x_i) | w angle.r phi_M (x_i) &<=>^(*) \
  Phi Y &= Phi Phi^T w &<=> \
  w_"ML" &= (Phi Phi^T)^(-1) Phi Y &
$

Man beachte, dass dies sehr ähnlich zu unserem Ansatz bei der Least Squares
regression aussieht.

$
  *: sum_(i=1)^n angle.l phi_M (x_i) | w angle.r phi_M (x_i)
  = sum_(i=1)^n angle.l phi_M (x_i) | phi_M (x_i) angle.r w
  = Phi Phi^T w
$

Allerdings ermöglicht MLE es uns nun damit auch $sigma^2$ auszurechnen. Der
genaue Weg dafür wird hier nicht gezeigt. Das Ergebnis sollte allerdings
ungefähr so aussehen:
$
  sigma_"ML"^2 = 1/n sum_(i=1)^n (y_i - y(x_i, w_"ML"))^2
$
#sub[Jan hats hier irgendwie hinbekommen $sigma (x_i)$ zu schreiben.]

Damit ergibt sich dann also die Wsk.-Verteilung $p(t|x; w_"ML", sigma_"ML")$, 
dass unsere gesuchte Funktion an $x$ den Wert $t$ annimmt.

#dangerous[Ab hier kommt etwas mehr Freitext bzw. freihändigere Interpretation
von Jans Folien. Zudem wird die obige Rechnung nicht mehr wirklcih fortgeführt.]

Nun haben wir auf der einen Seite die Funktion $t=f(x)=y(x,w_"ML")$ zur
Bestimmung des Werts von Datenpunkten und damit verbunden die Wsk. 
$p(t|x; w, sigma)$, dass $t$ der richtige Wert für $x$ ist.

Nun ist es unser Ziel eine tatsächliche Schätzung über den Funktionswert
$t$ für einen Datenpuntk $x$ abzugeben. Dafür können wir sogenannte
*Loss Functions* nutzen:

Im allgemeinen ist eine loss function erstmal eine Funktion 
$L: bb(R) times bb(R) -> bb(R)^+$, die zum einen unsere Schätzung $t$ und
den tatsächlichen Funktionswert $f(x)$ bekommt. Also $L(t,f(x))$. Diese gibt
an, wie falsch unsere Schätzung liegt bzw. was für einen Verlust wir im 
Vergleich zum eigentlichen Wert haben.

Nun wollen wir den erwarteten Verlust über alle Werte minimieren. Dafür
stellen wir zuerst einmal wieder die Gleichung dafür auf:
$
  bb(E) [L] = integral integral L(t,f(x))p(x,t) dif x dif t
$ 

Dazu betrachten wir jetzt einmal einen sehr simplen Fall der loss function und
zwar squared loss bzw. quadratic loss:
$
  L(t,f(x)) = (t - f(x))^2 => 
  bb(E) [L] = integral integral (t - f(x))^2 p(x,t) dif x dif t
$

Nun können wir wieder analystisch ein Minimum finden:

$
  diff / (diff f(x)) bb(E) [L] &= -2 integral (t - f(x)) p(x,t) dif t = 0 &<=> \
  integral t p(x,t) dif t &= f(x) integral p(x,t) dif t &<=> \
  integral t p(x,t) dif t &= f(x) p(x) &=> \
  f(x) &= integral t p(x,t)/p(x) dif t = integral t p(t | x) dif t \
  f(x) &= bb(E)_(t ~ p(t | x)) [t] =  bb(E) [t | x]
$

Damit erhalten wir für squared loss, dass die optimale regression Funktion
$bb(E) [t | x]$ von der Verteilung $p(t | x)$ ist.

Basierend auf unserem vorherigen Beispiel erhalten wir damit:
$
  f(x) = integral t p(t | x; y(x, w_"ML"), sigma) dif t
  = integral t cal(N) (t; y(x, w_"ML"), sigma^2) dif t = y(x,w_"ML")
$
#sub[Hätte man sich ggf. auch schon denken können. Haben jetzt durch die loss
function nichts dazugewonnen.]

=== Bayesian Linear Regression

Nun haben wir wohl wieder die üblichen Probleme, dass wir nur eine 
Punktschätzung machen. Darum wollen wir jetzt mal einen etwas mehr Bayesian
Ansatz probieren.

Dafür haben wir wieder Eingaben $X$, Ergebnisse $Y$ und Parameter $w$. Basierend
darauf können wir nun allgemein erstmal folgendes aufstellen:
- Prior: $p(w)$
- Likelihood: $p(Y | X,w)$ 
- Posterior: $p(w | X,Y)$

In unserem Beispiel packen wir erst einmal wieder Gaußverteilung auf die 
Parameter. Also $w ~ cal(N)(0,sigma_0^2 I)$. $sigma_0$ gibt dabei die
Genauigkeit der Verteilung vor. Genaueres dazu kommt später noch.

#note[$I$ steht für die Einheitsmatrix. Somit ist die Varianz auch eine Matrix,
weswegen es sich hier um eine Multivariate Gaußverteilung handelt. Wird hier
jetzt nicht genauer erklärt.]

#note[Wir verwenden den Erwartungswert $0$, um die Abweichung zu beschränken.
An sich ist hier aber eine beliebige Zahl möglich.]

Wir erhalten somit die genauen Verteilungen:
- Prior $p(w; sigma_0) = cal(N) (w; 0, sigma_0^2 I)$
- Posterior $p(w | X,Y; sigma_0, sigma)$
- Likelihood $p(Y | X,w; sigma)$

Sigma ist eben analog zu oben auch wieder die Standardabweichung der
Gaußverteilung.

Nun können wir gemäß MAP lösen, indem wir über $w$ maximieren. Dafür stellen
wir erstmal wieder den Logarithmus vom Posterior auf:
$
  log p(w | X,Y; sigma_0, sigma) &= log p(Y | X, w; sigma) 
  + log cal(N) (w; 0, sigma_0^2 I) \
  &= sum_(i=1)^n log cal(N) (y_i | x_i, w; y(x_i,w),sigma^2)
  + log cal(N) (w; 0, sigma_0^2 I) \
  &= - 1/(2 sigma^2) sum_(i=1)^n (y_i - y(x_i,w))^2 - 1/(2sigma_0^2)
  angle.l w | w angle.r
$

#note[Laut Jan ist hier noch ein $+ "const"$. Ist aber nicht wirklich relevant,
da wir eh gleich ableiten, wobei das wegfällt.]

Und wieder Gradient bilden und gleich 0 setzen:

$
  gradient_w log p(w | X, Y; sigma_0, sigma) 
  &= 1/sigma^2 sum_(i=1)^n (y_i - y(x_i,w)) - 1/sigma_0^2 w = 0 &<=> \
  &dots.v "(Folien)" &<=> \
  sigma^(-2) Phi Y &= (sigma^(-2) Phi Phi^T + sigma_0^(-2) I) w &<=> \
  w_"MAP" &= (Phi Phi^T + sigma^2/sigma_0^2 I)^(-1) Phi Y
$

#sub[JUHU endlich mal was neues.]

Zuerst fassen wir den Term $sigma^2 slash sigma_0^2$ zu $lambda$ zusammen.

Nun fragt sich bestimmt jeder vom Dorf bis zur Stadt: was macht dieses 
$lambda I$. Wie man in @lambda_complexity sehen kann, hat least squares (die
bisher genutzte Loss/Error Function, die wir minimiert haben, siehe auch unsere
Parameter Schätzungen von MLE) das "Problem", dass es für Punkte einen recht 
ähnlichen Wert annimmt. Dies ist eben dieses Tal im Graphen. Das ist eben ein 
Problem, weil dann bereits leichte Abweichung z.B. durch Rundungsfehler etc. 
bereits einen größeren Effekt auf die Wahl unserer Parameter, was eben schnell 
zu inkonsistenz (overfitting) führen kann. Deshalb fügen wir eben die 
"Bestrafung" $lambda I$ hinzu, damit wir dieses lange Tal in ein großes Minimum 
umwandeln, welches eben darauf abzielt unsere Parameter auf $0$ zu bewegen. 
Dadurch haben eben kleinere Änderungen nicht mehr so einen großen Effekt.

#figure(
  caption: [Effekt von $lambda$ auf Least Squares],
  image("images/lambda_complexity.png", height: 4cm)
) <lambda_complexity>

$"beta1"$, $"beta2"$ sind eben einfach Parameter von der visualisierten
Funktion und die z Achse beschreibt die Loss Function, also wie schlecht unsere
Parameter sind.

Damit können wir nun den allgemeinen Term für least squares error aufstellen:
$
  E_D (w) = 1/2 norm(Phi^T w - y)_2^2 = 1/2 sum_(i=1)^n (phi(x_i)^T w - y_i)^2
$
#sub[(wann auch immer wir den kennengelernt haben.)]
Dieser stellt eben den linken Graphen dar.

Dazu können wir nun unseren regression error aufstellen:
$
  E_W (w) = lambda/2 norm(w)_2^2 = lambda/2 sum_(i=1)^n w_i^2
$
#sub[Genauer wird jetzt hier nicht drauf eingegangen.]

Zusammen erhalten wir den rechten Graphen:
$
  E(w) = E_D (w) + E_W (w)
$

Jetzt würde man vermuten, dass man $lambda$ relativ hoch wählen sollte, damit
wir jegliche Fehler vermeiden. Das sorgt nur für ein gewisses Problem.

Denn was bisher noch nicht gesagt wurde, ist das $lambda$ bei uns auch 
kontrolliert, ob wir eher unseren beobachteten Daten, oder unserem Prior
vertrauen. Wählen wir ein relativ hohes $lambda$ vertrauen wir zu sehr unserem
Prior, wodurch wir eher eine Gerade Schätzen. Wählen wir hingegen ein zu kleines
$lambda$ bekommen wir eben wieder overfitting, beziehen also zu viele 
Datenpunkte ein. Wir sagen auch, dass $lambda$ die komplexität unseres Modells
kontrolliert. Dabei bedeutet ein kleineres $lambda$ eine größere Komplexität
und ein größeres $lambda$ eine niedrigere Komplexität.

Dazu betrachten wir nochmal $sigma^2 slash sigma_0^2$. $sigma^2$ ist hier der 
Parameter für die Gaußverteilung unserer Daten. Dieser ist fix und wir können 
diesen nicht anpassen. $sigma_0^2$ können wir hingegen anpassen. Wir erinnern
uns: Dieser kontrolliert die Varianz unseres Priors. Die obige Behauptung
können wir also hier auch wiederfinden: wählen wir ein kleines $sigma_0^2$ hat
unser prior eine geringe Varianz, wodurch dieser sehr stark zu einem konkreten
Wert tendiert -- wir legen also quasi einen festen Wert für den Prior fest.
Unser $lambda$ wird auch entsprechend groß, da der Nenner klein wird. Senken
wir anders herum unser $sigma_0^2$ erhöhen wir die Varianz auf unserem Prior --
dieser kann also eine größere Spanne an Werten annehmen und ist nicht mehr
konkret festgelegt. Dadurch haben wir also mehr Fähigkeit unsere Parameter an
unsere Daten anpassen, was sich analog in unserem $lambda$ wiederspiegelt.

Laut Jan ist ein $lambda$ zwischen $10^(-6) N$ bis $10^(-8) N$, wobei $N$ die
Größe des Datensatzes ist, am besten geeigent. $0.1 N$ ist hingegen schon ein
sehr niedrige Komplexität bzw. sehr viel vertrauen in den Prior.

#note[Jan teasert hiernach den Full Bayesian Regression Ansatz. Sofern dieser
später nochmal ausführlicher kommt wird er dort aufgehührt. Hier ist das gerade
nur unnötig Komplexität.]

== Probabilistic Classification

#note[Bitte nicht stark hier reinsteigern,  man wird nur umso stärker 
enttäuscht.]

Nun betrachten wir eine Methode, mit der man diese Funktion $f$ in einem
Classification Problem bestimmen kann. Dabei betrachten wir jedoch nur eine
sehr simple Methode. Diese heißt *Logistic Regression*. Diese hat die sehr
simple Voraussetzung, dass wir auf nur zwei Werte abbilden. Also $O={C_1,C_2}$.
Wir bezeichnen die einzelnen Komponenten unseres Bildbereich als Klassen,
weswegen wir diese auch als $C_i$ kennzeichnen.

Dafür wollen wir wieder ähnlich zu Bayesian Regression folgende Wsk. aufstellen:
- Posterior $p(C_1 | x)$
- Likelihood $p(x | C_1)$
- Prior $p(C_1)$
- Evidence $p(x)$

Damit können wir dann folgendes berechnen:
$
  p(C_1 | x) &= (p(x | C_1) p(C_1)) /p(x) = (p(x | C_1) p(C_1)) / 
  (sum_i p(x,C_i)) \
  &= (p(x | C_1) p(C_1))/(sum_(i=1)^2 p(x | C_i) p(C_i)) \
  &= (p(x |C_1) p(C_1)) / (p(x |C_1) p(C_1) + p(x | C_2) p(C_2)) \
  &= 1/(1+exp (-a)) = sigma(a) "mit" 
  a = log (p(x | C_1) p(C_1)) / (p(x | C_2) p(C_2))
$
$sigma(a)$ bezeichnet dabei die Sigmoid Funktion. Diese quetscht eine beliebige
relle Zahl in das Intervall $[0,1]$.

Nun ist es unser Ziel bestimmen zu können ob eine Eingabe $x$ zu einer der
beiden Klassen gehört. Wenn man sich nun mehrere Datenpunkte in einem Graphen
vorstellt (siehe Folie 86) wollen wir anschaulich nun diese Trennlinie in der
Mitte bestimmen. Damit sagen wir dann, dass alles auf der einen Seite zur einen
und alles auf der anderen Seite zur anderen Klasse gehört.

Wir stellen also $a=w x + epsilon_0$ und damit dann:
$
  p(C_1 | x) = sigma (w x + epsilon_0)
$

#note[Wieso genau wir das ganze über $a$ einsetzen können habe ich noch nicht
verstanden. Man beachte zudem, dass auf den Folien wieder $w$ als Vektor
angesehen wird. Da wir hier allerdings im Eindimensionalen sind macht das meines
erachtens wenig Sinn.]

Für bekannte Daten $X={x_1,...,x_n}$ und $Y={y_1,...,y_n}$, wobei für alle $y_i$
gilt:
$
  y_i = cases(0 quad &x_i "belongs to" C_1, 1 &x_i "belongs to" C_2)
$

Mit Maximum Likelihood Regression erhalten wir dann:
$
  p(Y | X; w, epsilon_0) &= product_(i=1)^n p(y_i | x_i; w, epsilon_0) \
  &=^* product_(i=1)^n p(C_1 | x_i; w, epsilon_0)^(1-y_i) 
    p(C_2 | x_i; w, epsilon_0)^(y_i) \
  &= product_(i=1)^n sigma (w x_i + epsilon_0)^(1-y_i)
    (1-sigma (w x_i + epsilon_0))^(y_i)
$

$*$: Wir können dies anwenden, da einer der beiden Wsk. einen Exponenten von 0
und der andere einen von 1 hat, wodurch wir am Ende wieder nur eine der beiden
Wsk. haben, aber halt nun entsprechend der Klasse geordnet.

Und ab hier bricht Jan dann ab. Seine Referenz zu Bishop scheint auch nur 
bedingt zu passen, da dort noch viel abgefahreners gemacht wird.

== Probabilistic Clustering

Im Vergleich zu davor haben wir nun nicht mehr so genaue Infos zu unseren
Datenpunkten. Wir wissen also z.B. nicht, zu welchen Klassen diese gehören
oder welche Klassen wir überhaupt haben. Dazu haben wir eben auch nicht mehr
unbedingt nur 2 mögliche Ausgänge sondern eben ggf. mehr Klassen.

Was wir also nun machen wollen ist Cluster -- also Gruppierungen -- in diesen 
uns bekannten Daten zu finden und basierend darauf Klassen zu erstellen.

Wir gehen also wieder in der Vermutung, dass unsere Daten von einer Verteilung
generiet wurden (bzw. mehreren Verteilungen). Und nun wollen wir wieder von
diesen Verteilungen die Parameter bestimmen. \
Wie zuvor auch verwenden wir hier wieder Gaußverteilungen.

Nun kann man mal naiv versuchen mit Log Likelihood die Erwartungswerte $mu_j$ zu
bestimmen. Die Standardabweichungen $sigma_j$ sind erstmal weniger relevant, da 
es uns primär um den Ort der Cluster geht.

Wir haben also $n$ Datenpunkte ${(x_1,z_1),...,(x_n,z_n)}$. Dazu haben wir $n$ 
(?) Klassen $C_1,...,C_n$.

Wir erhalten dann:
$
  cal(L) = log L(theta) &= sum_(i=1)^n log p(x_i | theta) \
  (diff cal(L)) / (diff mu_j) &= 0 \
  => hat(mu)_j &= (sum_(i=1)^n p(z_j | C_i) x_i)/(sum_(i=1)^n p(z_j | C_i))
$

Hier stoßen wir aber nun auf ein Problem, da wir ja eben diese $mu$ nutzen
wollen um unsere Cluster zu bestimmen. Jetzt brauchen wir aber eben dafür 
bereits eine Zuteilung in diese Cluster, wodurch wir eine zyklische Abhängigkeit 
haben.

#note[Ich kann keine Garantie geben, dass die Variablen korrekt benannt wurden,
Jans Folien sind hier sehr falsch.]

Ein anderer Ansatz ist, dass wir ähnlich zu davor wieder die Ableitung bestimmen
und uns dann wie eine Art Hill-Climbing Algorithmus zu einem Punkt bewegen,
wo der Gradient 0 wird. Dazu haben wir durch die Ableitung bereits die Steigung,
wodurch wir nicht stichprobenartig links und rechts von unserer aktuellen
Position testen müssen, sondern direkt darüber die optimale Richtung bestimmen
können.

Nun wollen wir aber noch einmal einen ganz neuen Ansatz betrachten. Nach
beobachten der Daten können wir nämlich die latent variable $j | x$ aufstellen,
die angibt, dass $x$ zur $j$-ten Klasse gehört. $j$ zählt dabei eben einfach
die Klassen durch, also $j=1$, $j=2$ etc. und gibt nicht direkt die konkrete
Klasse an.

Ähnlich zu davor können wir dann für unsere 2 Klassen wieder folgendes 
aufstellen:
#grid(columns: (1fr, 1fr), column-gutter: 1em)[
  $
    hat(mu)_1 = (sum_(i=1)^n p(1 | x_i) x_i) / (sum_(i_1)^n p(1 | x_i))
  $
][
  $
    hat(mu)_2 = (sum_(i=1)^n p(2 | x_i) x_i) / (sum_(i_1)^n p(2 | x_i))
  $
]

Wenn wir konkret unsere Verteilungen wissen können wir auch sagen, dass $x$
zu Klasse 1 gehört, wenn $p(j=1 | x) > p(j=2 | x)$ gilt.

Nun wissen wir ja aber nicht die Verteilung oder wie unsere Daten aussehen. Bzw.
welche Daten von welcher Verteilung erstellt bzw. maßgeblich beeinflusst wurden:
$
  p(x | theta) = sum_(i=1)^2 pi_i p(x | theta_i)
$

Ähnlich zu Bayesian können wir aber nach betrachten einzelner Daten einen
Posterior aufstellen:
$
  p(j=1 | x,theta) = p(j=1,x | theta)/p(x | theta)
  = (p(x | theta_1) p(j=1))/(sum_(i=1)^2 p(x | theta_i) p(i))
  = gamma_(j=1) (x)
$

Wir nennen $gamma_(j=1) (x)$ die responsibility der Klasse $j$ für den Wert $x$.

Und damit betrachten wir nun den Expectation-Maximation Algorithmus:


// TODO Folie 96+

#pagebreak()

#emoji.construction BIG TODO

MLE vs MAP:
MLE mit limitierten Daten ist gefährlich, da Varianz dann sehr niedrig. Somit 
ggf. Division durch 0. MAP hingegen durch Subjektivität robuster. 

Prior $p(theta)$ #sym.checkmark \
Likelihood $p(D | theta)$ #sym.checkmark \
Posterior $p(theta | D)$ #sym.checkmark \
Evidence $p(D)$ #sym.checkmark

$p(theta,D)$ nonsense

p. 49 $D = cal(X) times cal(Y)$ #sym.crossmark

w = parameters ??? #sym.checkmark

p. 72: I = Einheitsmatrix

; steht für | aber mit Parametern #sym.checkmark

Auffrischen: Multivariate Gaußverteilung

; bindet stärker #sym.checkmark

p. 73:  $sigma_0$ Parameter über Gauss Prior $w$ #sym.checkmark

p. 78: $lambda$ Kontroliiert wie sehr wir Daten vs Prior vertrauen. $lambda$
reduzieren erhöht komplexität \
Bessere Werte meist in $10^(-6)$ bis $10^(-8)$. $0.1N$ schon sehr hoch.
#sym.checkmark

#table(
  columns: 3,
  [], $y in {0,1}$, $y in bb(R)$,
  "beobachtbar", "Classification", "Regression",
  "nicht beobachtbar", "Clustering", "Dimensionale Reduction"  
)
Alles auf probability density estimation reduzierbar
"beobachtbar": wir wissen den Zielraum und für Beispiele den Zielwert

p.94: x: Zeit bis Ausbruch, y: Dauer #sym.crossmark

p.95: eigentliche unbekanntheiten: Anzahl an Datenpunkten, Verteilung selbst,
Parameter

\\hat{xyz} steht für eine schätzung

Bishop: Deep learning networks