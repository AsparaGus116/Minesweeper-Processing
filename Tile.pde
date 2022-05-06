enum State
  {
    BLANK,
    ONE,
    TWO,
    THREE,
    FOUR,
    FIVE,
    SIX,
    SEVEN,
    EIGHT,
    MINE,
    NULL
  }
  
int toInteger(State s)
{
  switch(s)
  {
    case BLANK:
    return 0;
    case ONE:
    return 1;
    case TWO:
    return 2;
    case THREE:
    return 3;
    case FOUR:
    return 4;
    case FIVE:
    return 5;
    case SIX:
    return 6;
    case SEVEN:
    return 7;
    case EIGHT:
    return 8;
    case MINE:
    return 9;
    default:
    return -1;
  }
}

State toState(int x)
{
  switch(x)
  {
    case 0:
    return State.BLANK;
    case 1:
    return State.ONE;
    case 2:
    return State.TWO;
    case 3:
    return State.THREE;
    case 4:
    return State.FOUR;
    case 5:
    return State.FIVE;
    case 6:
    return State.SIX;
    case 7:
    return State.SEVEN;
    case 8:
    return State.EIGHT;
    case 9:
    return State.MINE;
    default:
    return State.NULL;
  }
}

public class Tile
{
  private boolean finalBomb;
  private final int xPos;
  private final int yPos;
  
  private boolean isCovered;
  private State state;
  private int numFlags;
  private boolean hasBomb;
  private boolean flagged;
  
  public Tile(int xPos, int yPos, boolean hasBomb)
  {
    this.xPos = xPos;
    this.yPos = yPos;
    
    isCovered = true;
    
    numFlags = 0;
    this.hasBomb = hasBomb;
    flagged = false;
    
    finalBomb = false;
  }
  
  public void update()
  {
    
    PImage p;
    switch(state)
    {
      case BLANK:
      p = unCovered;
      break;
      case ONE:
      p = one;
      break;
      case TWO:
      p = two;
      break;
      case THREE:
      p = three;
      break;
      case FOUR:
      p = four;
      break;
      case FIVE:
      p = five;
      break;
      case SIX:
      p = six;
      break;
      case SEVEN:
      p = seven;
      break;
      case EIGHT:
      p = eight;
      break;
      case MINE: 
      p = mine;
      break;
      default:
      p = eight;
      break;
    }
    if(flagged)
    {
      p = flag;
    }
    else if(isCovered)
    {
      p = covered;
    }
    else if(finalBomb)
    {
      p = mineDead;
    }
      image(p, xPos, yPos + 48, tileWidth, tileHeight);
      
       
  }
  
  public void decideState()
  {
    if(!hasBomb)
    {
      state = toState(getNumBombs(board, xPos / tileWidth, yPos / tileHeight));
    }
    else
    {
      state = State.MINE;
    }
    
  }
  
  public State getState()
  {
    return state;
  }
  
  public void flag()
  {
    flagged = true;
    decideState();
  }
  
  public void unFlag()
  {
    if(!gameOver)
    {
      flagged = false;
      decideState();
    }
    
  }
  
  public void finalBomb()
  {
    finalBomb = true;
  }
  
  public boolean isFlagged()
  {
    return flagged;
  }

  public boolean isFulfilled()
  {
    if(flagged || hasBomb)
    {
      return false;
    }
    numFlags = getNumFlags(board, xPos / tileWidth, yPos / tileHeight);
    return getNumBombs(board, xPos / tileWidth, yPos / tileHeight) == numFlags;
  }
  
  public boolean hasBomb()
  {
    return hasBomb;
  }
  
  public int getX()
  {
    return xPos;
  }
  
  public int getY()
  {
    return yPos;
  }
  
  
  
  public void pressRadius(int x)
  {
    Tile tile;
    isCovered = false;
    for(int i = 0; i < board.getWidth(); i++)
    {
      for(int j = 0; j < board.getHeight(); j++)
      {
        tile = board.getTile(i,j);
        if(distance(this, tile) < tileWidth * Math.sqrt(2) * x && (tile != this))
        {
          if(tile.isCovered())
          {
            tile.decideState();
            if(tile.getState() == State.BLANK)
            {
              tile.pressRadius(1);
            }
            else if(!tile.isFlagged())
            {
              tile.press();
            }
            
          }
          
        }
      }
    }
    
  }
  
  public void removeMine()
  {
    hasBomb = false;
    decideState();
  }
  
  
  public void press()
  {
    isCovered = false;
    decideState();
  }

  
  public boolean isCovered()
  {
    return isCovered;
  }
  
  public void setMine()
  {
    hasBomb = true;
    decideState();
  }
}
