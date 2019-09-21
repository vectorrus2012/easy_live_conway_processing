import static java.awt.event.KeyEvent.*;
final int cell_size = 20; // размер одной закрашенной клетки
final int elem = 33; //Количество возможных элементов на сетке
byte[][] current = new byte [elem][elem]; //Текущее поколение
byte[][] next = new byte [elem][elem]; //Следующее поколение
//Текущее поколение:
//1 - Клетка жива
//0 - мертва

//Следующее поколение
//1 - Рождение новой
//0 - умирание от переполнения

boolean randomed = false; // Была ли рандомная генерация
boolean start_cycle = false; // Запуск цикла
boolean draw_gr = true; // Рисовать ли сетку
boolean help_showed = true; 

//Настройка размера окна
void setup() {
  size(1020,530); // Размер окна
  clear_grid();
  textSize(14); 
  help_msg();
}
 
void drawGrid() { // Нарисовать сетку 33x33
  background( 255 ); // Цвет фона белый
  stroke( 225 ); // Цвет линий - белый
  for ( int i = 0; i < 64; i++ ) 
  { 
    line( i*cell_size, 0, i*cell_size, height ); // Горизонтальные
  }
  for ( int i = 0; i < 48; i++ ) 
  { 
    line( 0, i*cell_size, width, i*cell_size ); // Вертикальные
  }
  stroke( 0 ); // Цвет линий - чёрный
  fill( 0, 0, 0 ); //Задать чёрный цвет заливки
}

void help_msg(){
  text("F1 - показать эту справку, S - одна итерация хода, c - очистка экрана и всех поколений, ",10,20); //Вывод текста
  text("A - циклическая итерация хода, j - убрать, показать сетку,",10,40); 
  text("R - случайно сгенерировать начальный набор",10,60);
}

// Рисование жизни в цикле
void draw() { 
  if (start_cycle == true) {
    cycle();  // Провести итерацию цикла
    copy_arrays(next, current); // Присвоить текущему поколению массив следующих.
    delay (200);
  }
}  

//Не выходить за пределы клетки
float check_coordinate(float coord){
  float tmp = coord % cell_size;
  float output = coord;
  if (tmp != 0) {
    output = coord - tmp;
  }
  return output;
}

//Расстановка начальных клеток
void mouseClicked() {
  if (help_showed == true) {
    clear_grid();
    help_showed = false;
  }
  // Получить координаты мыши
  float x_coord = check_coordinate (mouseX); //По х
  float y_coord = check_coordinate (mouseY); //По y
  if (current[int(x_coord)/cell_size][int(y_coord)/cell_size] == 0) { // Если не поставлено 
  current[int(x_coord)/cell_size][int(y_coord)/cell_size] = 1; // В массив текущего поколения заносится то, что клетка жива
  rect( x_coord, y_coord, cell_size, cell_size); // Нарисовать клетку
  }
  else { // Если было поставлено
    clear_grid(); // Очистить окно
    current[int(x_coord)/cell_size][int(y_coord)/cell_size] = 0; // Делаем клетку неживой 
    drawing(current); // Перерисовать текущее поколение
  }
}

//Проверка правила для клетки по координатам X,Y
void check_rules(int i, int j) {  
  int lifecount = 0; // Количество живых клеток 
  //Суммируем всё вокруг клетки
  for (int k = i-1; k < i+2; k++) {
    for (int n = j-1; n < j+2; n++) {
      lifecount = lifecount + current[k][n];  
    }
  }
  //Вычитаем текущую клетку
  lifecount = lifecount - current[i][j];
  if (lifecount == 3 && current[i][j] == 0) {
    next[i][j] = 1; // Возрождение жизни, если у неживой клетки 3 соседа
  }
  if ((lifecount <2 || lifecount >3) && (current[i][j] == 1)) {
    next[i][j] = 0; // Умирание клетки, если меньше двух или больше 3 соседей 
  }
  if ((lifecount == 2 || lifecount == 3) && current[i][j] == 1) { // Если у живой клетки 2 или 3 соседа, продолжает жить
    next[i][j] = 1;
  }
}


//Нарисовать итерацию
void drawing(byte [][] arr) {
  clear_grid();
  for (int i = 1; i<=elem-1; i++) {
  for (int j = 1; j<=elem-1; j++) {
    if (arr[i][j] == 1) {
      rect(i*cell_size, j*cell_size, cell_size, cell_size); // Нарисовать клетку
    }
}
}
}

// Сгенерировать случайные начальные клетки
void random_generate () {
for (int i = 1; i<elem-1; i++) {
  for (int j = 1; j<elem-1; j++) {
    if (int(random(2)) == 1) {
      if ((int(random(2)) == int(random(2)))) {
        current[i][j] = byte(random(2));
    }
    }
    if (current[i][j] == 1) {
      rect(i*cell_size, j*cell_size, cell_size, cell_size); // Рисование случайной клетки
    }
}
}
}

// Очистка массива
void clear_array (byte[][] r) {
    for (int i = 1; i<elem-1; i++) {
      for (int j = 1; j<elem-1; j++) {
        r[i][j] = 0;  // Очистка массива
    }
    }
}

void copy_arrays (byte [][] src, byte [][] dst) {
  for (int i = 1; i<elem-1; i++) {
      for (int j = 1; j<elem-1; j++) {
        dst[i][j] = src[i][j];  // Копирование массива
    }
    }
}

// Итерация цикла жизни
void cycle(){
    //Проходим по элементам текущего поколения
    for (int i = 1; i<elem-1; i++) {
      for (int j = 1; j<elem-1; j++) {
        check_rules(i,j);  // Проверка правил
    }
    }
    drawing(next);  // Рисование из массива следующих поколений
}

// Очистка окна
void clear_grid(){
  clear();
  if (draw_gr == true) { // В зависимости от флага рисовать сетку
    drawGrid();
  }
  else {
    background( 255 ); // Цвет фона белый
    stroke( 0 ); // Цвет линий - чёрный
    fill( 0, 0, 0 ); //Задать чёрный цвет заливки
  }
}

void keyPressed() { 
if (keyCode == VK_F1 ) {  // При нажатии f1 выводиться справка
  if (help_showed == true) {
    help_showed = false;
    clear_grid();
  }
  else {
    draw_gr = false;
    clear_grid();
    draw_gr = true;
    help_msg();
    help_showed = true;
    start_cycle = false;
  }
}
if ((key == 's' || key == 'S') || (key == 'Ы' || key == 'ы')) { //При нажатии на любую клавищу запускается 1 итерация
  cycle();
  copy_arrays(next, current);
  start_cycle = false;
}
if ((key == 'c' || key == 'C') || (key == 'с' || key == 'С') ) { // Очистка сетки
  clear_grid(); // Очистка сетки
  clear_array(current); // Очистка массива текущих поколений
  clear_array(next); // Очистка массива следующих поколений
  start_cycle = false; // Перевести цикл в ложь
}

if ((key == 'J' || key == 'j') || (key == 'о' || key == 'О')) {  // Убрать/показать сетку
  if (draw_gr == true) { // Если сетка нарисована, то 
    draw_gr = false;  // Не рисовать сетку
    clear_grid(); // Очистка всего окна и установление цвета для бактерий
    drawing(next);  // Нарисовать из текущего массива
  }
  else {
    draw_gr = true; // Флаг рисование сетки включён
    clear_grid(); // Очистка окна и нарисовать сетку
    drawing(next); // Нарисовать расположение бактерий
  }
}

if ((key == 'A' || key == 'a') || (key == 'ф' || key == 'Ф')) {  // Циклическое выполнение
  start_cycle = true;
}
if ((key == 'r' || key == 'R') || (key == 'к' || key == 'К') ) { // Рандомная генерация начальных клеток
  if (randomed == false) {
    clear_array(next);
    random_generate();
    randomed = true;
}
else {  // Если уже сгенерировано, то стереть сетку и сгенерировать ещё раз
  clear_grid();
  clear_array(next);
  random_generate();
}
start_cycle = false;
}
}
