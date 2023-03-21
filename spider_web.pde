import java.util.Comparator;
import java.util.Collections;
int TILE_SIZE = 10;
int xSize = 80;
int ySize = 80;
int[][] tilemap = new int[xSize][ySize];

ArrayList<Web> webs = new ArrayList<>();

void setup() {
  size(800, 800);
  stroke(0);
}

void draw() {
  stroke(150);
  for (int x = 0; x < xSize; x++) {
    for (int y = 0; y < ySize;y++) {
      int tileType = tilemap[x][y];
      switch (tileType) {
        case 0:
          fill(255);
          break;
        case 1:
          fill(0);
          break;
      }
      rect(x * TILE_SIZE, y * TILE_SIZE, TILE_SIZE, TILE_SIZE);
    }
  }
  
  for(Web web: webs) {
    web.render();
  }
  
  if(mousePressed) {
    int x = mouseX / TILE_SIZE;
    int y = mouseY / TILE_SIZE;
    if (x >= 0 && x < xSize && y >= 0 && y < ySize) {
      if (mouseButton == LEFT) {
        tilemap[x][y] = 1;
      } else if (mouseButton == RIGHT) {
        tilemap[x][y] = 0;
      }
    }
  }
}

void mousePressed(){
  if (mouseButton == CENTER) {
    int x = mouseX / TILE_SIZE;
    int y = mouseY / TILE_SIZE;
    ArrayList<Web> rem = new ArrayList<>();
    for(Web web: webs) {
      if(dist(x, y, web.x, web.y) < 20) {
        rem.add(web);
      }
    }
    for(Web r : rem) webs.remove(r);
    if (x >= 0 && x < xSize && y >= 0 && y < ySize) {
      webs.add(new Web(x, y));
    }
  }
}
