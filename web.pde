class Web {
  float x;
  float y;
  boolean isOk;
  ArrayList<Yarn> yarns;
  
  Web(int $x, int $y) {
    this.x = $x;
    this.y = $y;
    int f = 0;
    yarns = new ArrayList<>();
    
    // === CHECK SPACE ===
    for(int i = 0;i < 360;i++) {
      if(raycast((int)x, (int)y, cos(i / 180.0 * PI), sin(i / 180.0 * PI), 7) != null) {
        return;
      }
      if(raycast((int)x, (int)y, cos(i / 180.0 * PI), sin(i / 180.0 * PI), 35) != null) {
        f += 1;
      }
    }
    if(f / 360.0 < 0.5) return;
    
    // === MAIN ===
    for(int i = 0;i < 50;i++) {
      float a = random(TWO_PI);
      RayHit hA = raycast((int)x, (int)y, cos(a), sin(a), 30);
      RayHit hB = raycast((int)x, (int)y, -cos(a), -sin(a), 30);
      if(hA != null && hB != null) {
        x = (hA.x + hB.x) / 2.0;
        y = (hA.y + hB.y) / 2.0;
        Yarn main1 = new Yarn(x, y, hA.x, hA.y, color(100, 255, 0));
        yarns.add(main1);
        Yarn main2 = new Yarn(x, y, hB.x, hB.y, color(100, 255, 0));
        yarns.add(main2);
        break;
      }
      if(i == 49) return;
    }
    
    // === SECONDARY ===
    float m = random(2) + 5;
    int b = 0;
    for(int k = 0;k < m;k++) {
      for(int i = 0;i < 100;i++) {
        float a = random(TWO_PI);
        RayHit h = raycast((int)x, (int)y, cos(a), sin(a), 30);
        if(h != null) {
          boolean foundErr = false;
          for(Yarn y : yarns) {
            if(angleBetween(a, y.angle()) < PI / 6.0) foundErr = true;
            if(angleBetween(a, -y.angle()) < PI / 6.0) foundErr = true;
          }
          if(foundErr) continue;
          
          Yarn s = new Yarn(x, y, h.x, h.y, color(0, 150, 255));
          yarns.add(s);
          b ++;
          break;
        }
      }
    }
    if(b < 3) return;
    
    // === sort by angle ===
    Collections.sort(yarns, new Comparator<>() {
      @Override
      public int compare(Yarn y1, Yarn y2 ) {
        return (int) (y1.angle() * 360 - y2.angle() * 360);
      }
    });
    
    // === AROUND ===
    int l = yarns.size();
    Yarn p = yarns.get(l-1);
    int n = 0;
    float ph = 1.5;
    while(true) {
      Yarn y = yarns.get(n%l);
      float h = (n / (float)l + 1) * 1.5;
      if(min(p.len(), 20) < ph || min(y.len(), 20) < h) break;
      Yarn ynew = new Yarn(p.startX + cos(p.angle()) * ph, p.startY + sin(p.angle()) * ph, y.startX + cos(y.angle()) * h, y.startY + sin(y.angle()) * h, color(0, 0, 255));
      yarns.add(ynew);
      p = y;
      ph = h;
      n ++;
    }
    
    
    isOk = true;
  }
  
  void render(){
    noFill();
    if(!isOk) {
      stroke(255, 0, 0);
    } else {
      stroke(0);
    }
    ellipse(x * TILE_SIZE + TILE_SIZE / 2, y * TILE_SIZE + TILE_SIZE / 2, 20 * TILE_SIZE, 20 * TILE_SIZE);
    for(Yarn y:yarns) {
      stroke(y.c);
      line(y.startX * TILE_SIZE + TILE_SIZE / 2, y.startY * TILE_SIZE + TILE_SIZE / 2, y.endX * TILE_SIZE + TILE_SIZE / 2, y.endY * TILE_SIZE + TILE_SIZE / 2);
    }
  }
}

class Yarn {
  float startX;
  float startY;
  float endX;
  float endY;
  color c;
  
  Yarn(float sx, float sy, float ex, float ey, color col) {
    startX = sx;
    startY = sy;
    endX = ex;
    endY = ey;
    c = col;
  }
  
  float slope() {
    return (endX-startX) / (endY-startY); 
  }
  
  float angle() {
    return atan2(endY-startY, endX-startX);
  }
  
  float len() {
    return dist(startX, startY, endX, endY);
  }
}
