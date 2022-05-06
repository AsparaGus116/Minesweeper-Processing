import lord_of_galaxy.timing_utils.*;

Stopwatch s = new Stopwatch(this);

PImage num0;
PImage num1;
PImage num2;
PImage num3;
PImage num4;
PImage num5;
PImage num6;
PImage num7;
PImage num8;
PImage num9;

PImage one;
PImage two;
PImage three;
PImage four;
PImage five;
PImage six;
PImage seven;
PImage eight;
PImage flag;
PImage mine;
PImage mineDead;
PImage covered;
PImage unCovered;

PImage dead;
PImage cool;
PImage happy;
PImage risky;

PImage redoUnpressed;
PImage redoPressed;

//static boolean isInMenu = true;

static boolean boardMade = false;

static boolean gameOver = false;
static boolean risk = false;

static boolean firstPress = true;

static boolean redoIsPressed = false;

//add functionality for completion to be based on tiles uncovered, NOT tiles flagged

static int len = 30;
static int wide = 16;
static int mines = 99;

static int minesUnflagged = mines;

static Board board;

static int tileWidth = 32;
static int tileHeight = 32;

int distance(Tile first, Tile second)
  {
    int x = first.getX() - second.getX();
    int y = first.getY() - second.getY();
    return (int)Math.sqrt(Math.pow(x, 2.0) + Math.pow(y, 2.0));
  }

int getNumBombs(Board b, int row, int col)
{
  int total = 0;
  for(int i = 0; i < b.getWidth(); i++)
  {
    for(int j = 0; j < b.getHeight(); j++)
    {
      if(distance(b.getTile(row, col), b.getTile(i,j)) < tileWidth * Math.sqrt(2) + 1)
      {
        if(b.getTile(i,j).hasBomb())
        {
          total++;
        }
      }
      
    }
  }
  return total;
}

int getNumFlags(Board b, int row, int col)
{
  int total = 0;
  for(int i = 0; i < b.getWidth(); i++)
  {
    for(int j = 0; j < b.getHeight(); j++)
    {
      if(distance(b.getTile(row, col), b.getTile(i,j)) < tileWidth * Math.sqrt(2) + 1)
      {
        if(b.getTile(i,j).isFlagged())
        {
          total++;
        }
      }
      
    }
  }
  return total;
}

void setup()
{
  num0 = loadImage("/images/Num0.png");
  num1 = loadImage("/images/Num1.png");
  num2 = loadImage("/images/Num2.png");
  num3 = loadImage("/images/Num3.png");
  num4 = loadImage("/images/Num4.png");
  num5 = loadImage("/images/Num5.png");
  num6 = loadImage("/images/Num6.png");
  num7 = loadImage("/images/Num7.png");
  num8 = loadImage("/images/Num8.png");
  num9 = loadImage("/images/Num9.png");
  
  one = loadImage("/images/One.png");
  two = loadImage("/images/Two.png");
  three = loadImage("/images/Three.png");
  four = loadImage("/images/Four.png");
  five = loadImage("/images/Five.png");
  six = loadImage("/images/Six.png");
  seven = loadImage("/images/Seven.png");
  eight = loadImage("/images/Eight.png");
  flag = loadImage("/images/Flag.png");
  mine = loadImage("/images/Mine.png");
  mineDead = loadImage("/images/MineDead.png");
  covered = loadImage("/images/Covered.png");
  unCovered = loadImage("/images/Uncovered.png");
  
  dead = loadImage("/images/Dead.png");
  cool = loadImage("/images/Cool.png");
  happy = loadImage("/images/Happy.png");
  risky = loadImage("/images/Risky.png");
  
  redoUnpressed = loadImage("/images/RedoUnpressed.png");
  redoPressed = loadImage("/images/RedoPressed.png");
  
  size(200,400);
  surface.setTitle("Minesweeper (AsparaGus116 2022)");
  surface.setIcon(loadImage("/images/MS.png"));
  surface.setLocation(100, 100);
}



void mousePressed()
{
  if(mouseX >= tileWidth * board.getWidth() / 3 - 48 && mouseX < tileWidth * board.getWidth() / 3 && mouseY < 48)
  {
    redoIsPressed = true;
  }
}
void mouseReleased()
{
  if(mouseX >= tileWidth * board.getWidth() / 3 - 48 && mouseX < tileWidth * board.getWidth() / 3 && mouseY < 48)
  {
    board = new Board(len, wide, mines);
  
    board.generateBoard();
    
    firstPress = true;
    redoIsPressed = false;
    gameOver = false;
    minesUnflagged = mines;
    s.reset();
    image(happy, board.getWidth() * tileWidth / 3 * 2, 0, 48, 48);
  }
  else if(redoIsPressed)
  {
    redoIsPressed = false;
  }
  if(mouseX > 0 && mouseX < tileWidth * board.getWidth() &&
     mouseY > 48 && mouseY < tileHeight * board.getHeight() + 48)
     {
      Tile tile = board.getTileFromPos(mouseX, mouseY - 48);
        if(mouseButton == RIGHT)
        {
          if(!tile.isFlagged() && tile.isCovered())
          {
            tile.flag();
            minesUnflagged--;
          }
          else if(tile.isCovered())
          {
            tile.unFlag();
            minesUnflagged++;
          }
        }
        else if(mouseButton == LEFT && !tile.isFlagged())
        {
          if(firstPress)
          {
            s.start();
            while(tile.getState() != State.BLANK)
            {
              board.clearMines();
              board.generateBoard();
              tile.decideState();
            }
            firstPress = false;
          }
          
          if(tile.getState() == State.BLANK)
          {
            tile.pressRadius(1);
          }
          else
          {
            tile.press();
          }
        }
        else if(mouseButton == CENTER && tile.isFulfilled() && !tile.isCovered())
        {
          tile.pressRadius(1);
          risk = true;
          image(risky, board.getWidth() * tileWidth / 3 * 2, 0, 48, 48);
        }
     }
}

boolean checkWin(Board b)
{
  for(Tile[] row : b.getBoard())
  {
    for(Tile element : row)
    {
      if((element.hasBomb() && !element.isFlagged()) || 
          !element.hasBomb() && element.isCovered())
      {
        return false;
      }
      
    }
  }
  return true;
}

void displayNumber(int x, int topLeft)
{
  if(x <= 0)
  {
    image(num0, topLeft,0,26,48);
    image(num0, topLeft + 26,0,26,48);
    image(num0, topLeft + 52,0,26,48);
  }
  else
  {
    switch(x / 100)
    {
      case 0:
      image(num0, topLeft,0,26,48);
      break;
      case 1:
      image(num1,topLeft,0,26,48);
      break;
      case 2:
      image(num2, topLeft,0,26,48);
      break;
      case 3:
      image(num3, topLeft,0,26,48);
      break;
      case 4:
      image(num4, topLeft,0,26,48);
      break;
      case 5:
      image(num5, topLeft,0,26,48);
      break;
      case 6:
      image(num6, topLeft,0,26,48);
      break;
      case 7:
      image(num7, topLeft,0,26,48);
      break;
      case 8:
      image(num8, topLeft,0,26,48);
      break;
      default:
      image(num9, topLeft,0,26,48);
    }
    
    switch((x / 10) % 10)
    {
      case 0:
      image(num0, topLeft + 26,0,26,48);
      break;
      case 1:
      image(num1, topLeft + 26,0,26,48);
      break;
      case 2:
      image(num2, topLeft + 26,0,26,48);
      break;
      case 3:
      image(num3, topLeft + 26,0,26,48);
      break;
      case 4:
      image(num4, topLeft + 26,0,26,48);
      break;
      case 5:
      image(num5, topLeft + 26,0,26,48);
      break;
      case 6:
      image(num6, topLeft + 26,0,26,48);
      break;
      case 7:
      image(num7, topLeft + 26,0,26,48);
      break;
      case 8:
      image(num8, topLeft + 26,0,26,48);
      break;
      default:
      image(num9, topLeft + 26,0,26,48);
    }
    
    switch(x % 10)
    {
      case 0:
      image(num0, topLeft + 52,0,26,48);
      break;
      case 1:
      image(num1, topLeft + 52,0,26,48);
      break;
      case 2:
      image(num2, topLeft + 52,0,26,48);
      break;
      case 3:
      image(num3, topLeft + 52,0,26,48);
      break;
      case 4:
      image(num4, topLeft + 52,0,26,48);
      break;
      case 5:
      image(num5, topLeft + 52,0,26,48);
      break;
      case 6:
      image(num6, topLeft + 52,0,26,48);
      break;
      case 7:
      image(num7, topLeft + 52,0,26,48);
      break;
      case 8:
      image(num8, topLeft + 52,0,26,48);
      break;
      default:
      image(num9, topLeft + 52,0,26,48);
    }
  }
}

void decideState()
{
  
  while(!mousePressed)
  {
    image(covered, 20, 50, 160, 75);
  }
}

void draw()
{

  if(!boardMade)
  {
   board = new Board(len, wide, mines);

    surface.setSize(board.getWidth() * tileWidth, board.getHeight() * tileHeight + 48);
    
    board.generateBoard();
    boardMade = true;
  }
  displayNumber(minesUnflagged, 0); // Shows mine count
  displayNumber(s.minute() * 60 + s.second(), board.getWidth() * tileWidth - 78);
  if(!redoIsPressed)
  {
    image(redoUnpressed, tileWidth * board.getWidth() / 3 - 48, 0,48,48);
  }
  else
  {
    image(redoPressed, tileWidth * board.getWidth() / 3 - 48, 0,48,48);
  }
  if(!risk && !gameOver)
  {
    image(happy, board.getWidth() * tileWidth / 3 * 2, 0, 48, 48);
  }
  
  for(Tile[] row : board.getBoard())
  {
    for(Tile tile : row)
    {
      tile.update();
      if(checkWin(board) && !gameOver)
      {
        s.pause();
        image(cool, board.getWidth() * tileWidth / 3 * 2, 0, 48, 48);
        gameOver = true;
      }
      if(tile.hasBomb() && !tile.isCovered() && !gameOver && !tile.isFlagged())
      {
        s.pause();
        board.uncover();
        gameOver = true;
        tile.finalBomb();
        image(dead, board.getWidth() * tileWidth / 3 * 2, 0, 48, 48);
      }
      
    }
  }
  
}
