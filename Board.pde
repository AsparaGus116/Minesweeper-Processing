import java.util.*;

public class Board
{
  private int width;
  private int height;
  private Tile[][] board;
  private int[] mines;
  private Random random;
  
  public Board(int width, int height, int mineCount)
  {
    this.width = width;
    this.height = height;
    
    board = new Tile[width][height]; 
    mines = new int[mineCount];
    
  }
  
  public Tile[][] getBoard()
  {
    return board;
  }
  
  public int getWidth()
  {
    return width;
  }
  
  public int getHeight()
  {
    return height;
  }
  
  private boolean findOccurrences(int[] arr, int x)
  {
    for(int element : arr)
    {
      if(element == x)
      {
        return true;
      }
    }
    return false;
  }
  
  private void generateMines()
  {
    random = new Random();
    int rand = random.nextInt(width * height);
    for(int i = 0; i < mines.length; i++)
    {
      while(findOccurrences(mines, rand))
      {
        rand = random.nextInt(width * height);
      }
      mines[i] = rand;
    }
  }
  
  public void uncover()
  {
    for(int i = 0; i < width; i++)
    {
      for(int j = 0; j < height; j++)
      {
        board[i][j].unFlag();
        board[i][j].press();
      }
    }
  }
  
  private void setMines()
  {
    int row;
    int col;
    for(int i = 0; i < mines.length; i++)
    {
      row = mines[i] % getWidth();
      col = mines[i] / getWidth();
      board[row][col].setMine();
    }
    
  }
  
  public void clearMines()
  {
    for(int i = 0; i < width; i++)
    {
      for(int j = 0; j < height; j++)
      {
        board[i][j].removeMine();
      }
    }
  }
  
  public void generateBoard()
  {
    
    generateMines();
    
    for(int i = 0; i < width; i++)
    {
      for(int j = 0; j < height; j++)
      {
        board[i][j] = new Tile(i * tileWidth, j * tileHeight, false);
      }
    }
    
    setMines();
    
    for(int i = 0; i < width; i++)
    {
      for(int j = 0; j < height; j++)
      {
        board[i][j].decideState();
      }
    }
    
  }
  
  Tile getTile(int row, int col)
  {
    return board[row][col];
  }
  
  
  Tile getTileFromPos(int xPos, int yPos)
  {
    return board[xPos / tileWidth][yPos / tileHeight]; //<>//
  }
}
