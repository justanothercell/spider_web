RayHit raycast(int $x, int $y, float $dx, float $dy, int len) {
  float x = $x;
  float y = $y;
  float d = sqrt($dx*$dx+$dy*$dy);
  float dx = $dx/d;
  float dy = $dy/d;
  float walked = 0;
  while(walked < len) {
    if (x >= 0 && x < xSize && y >= 0 && y < ySize) {
       if(tilemap[(int)x][(int)y] > 0) {
         RayHit hit = new RayHit();
         hit.dist = (int) walked;
         hit.x = (int) x;
         hit.y = (int) y;
         return hit;
       }
       x += dx/2;
       y += dy/2;
       walked += d/2;
    } else { 
      return null;
    }
  }
  return null;
}

class RayHit {
  int x;
  int y;
  int dist;
}

float angleBetween(float a1, float a2) {
    float angle = abs(a2 - a1) % (2 * PI);
    if (angle > PI) {
        angle = 2 * PI - angle;
    }
    return angle;
}
