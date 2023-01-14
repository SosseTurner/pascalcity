unit Tilemap;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls, LazLogger, Math;
type
    Building = record
      id:             Integer;
      residents:      Integer;        // Bei Industrien als Arbeitsplätze
      maxResidents:   Integer;
      level:          Integer;
      happiness:      Integer;        // In prozent | 0 --> 100
      isOnFire:       Boolean;
      health:         Integer;        // In prozent | 0 --> 100
      isParentTile:   Boolean;

  end;

var
  terrain: array of array of  Integer;
  buildings: array of array of Building;
  tileArr: array[0..40] of array[0..20] of TBitmap;
  screenWidth, screenHeight:  Integer;
  offsetX, offsetY : Integer;
  mapWidth, mapHeight: Integer;
  tile: TBitmap;

function FormCoordsToTile(x,y :Integer):TPoint;
function GetTileBitmap(x, y: Integer):TBitmap;
procedure LoadTiles();
procedure GenerateMap();
procedure PlaceMultiTile(tileX, tileY, width, height, id: Integer);
procedure DestroyMultiTile(tileX, tileY, width, height: Integer);
procedure PlaceBuildingTile(x, y, id : Integer);
procedure DestroyBuildingTile(x, y: Integer);
function GetMinimapColor(id:Integer):TColor;

implementation

// World Generation durch Cellular Automata
procedure WorldCellularAutomata();
var iteratedWorld: array of array of Integer;
  x, y, i, x2, y2: Integer;
begin
  SetLength(iteratedWorld, mapWidth, mapHeight);
  for x:=0 to mapWidth-1 do
  begin
    for y:=0 to mapHeight-1 do
    begin
      i:=0;
      for x2:=-1 to 1 do
      begin
        for y2:=-1 to 1 do
        begin
          if (x+x2>0) and (x+x2<mapWidth) and (y+y2>0) and (y+y2<mapHeight) then
          begin
            if terrain[x+x2][y+y2]=1 then
              inc(i);
          end;

        end;
      end;

      if i<=3 then
        iteratedWorld[x][y]:=1
      else
        iteratedWorld[x][y]:=0;
    end;
  end;

  terrain:=iteratedWorld;

end;

procedure GenerateMap();
var x, y, i: Integer;
begin

  // Karte wird zufällig Generiert
  for x:=0 to mapWidth-1 do
  begin
    for y:=0 to mapHeight-1 do
    begin
      // n Prozent der Tiles sind Grass
      if (Random(100)+1)>63 then
        terrain[x][y]:=1
      else
        terrain[x][y]:=0;
      end;
  end;

  for i:=0 to 10 do
    WorldCellularAutomata();
end;

function GetParentTilePosition(tileX, tileY, width, height: Integer):TPoint;
var id, x, y : Integer;
begin
  id:=buildings[tileX][tileY].id;

  for x:=0 to width-1 do
  begin
    for y:=0 to height-1 do
    begin
      if (buildings[tileX-x][tileY-y].isParentTile) and (buildings[tileX-x][tileY-y].id=id) then
      begin
        GetParentTilePosition.X:=tilex-x;
        GetParentTilePosition.Y:=tiley-y;
      end;
    end;
  end;
end;

function GetMultiTileBitmap(tileX, tileY, width, height: Integer):TBitmap;
var x, y, id, index: Integer;
  parentPos:TPoint;
begin
  id:=buildings[tileX][tileY].id;
  parentPos:=GetParentTilePosition(tileX, tileY, width, height);

  x:=tileX-parentPos.X;
  y:=tileY-parentPos.Y;
  index:=(width*y)+x;
  GetMultiTileBitmap:=tileArr[id][index]
end;

function BuildAutoTileTerrain(x, y, ID, targedId: Integer):TBitmap;
begin
  // Die Tiles werden durch 4 einzelne Stücken zusammengesetzt
  // Nur zwischen Wasser(0) und Land(1) möglich
  // Refactoring nötig um zwischen mehren Tiles zu unterscheiden
  tile.Canvas.Clear;

  // Oben Links
  if terrain[x][y-1]=targedId then
  begin
      if terrain[x-1][y]=targedId then
      begin
        tile.Canvas.Draw(0, 0, tileArr[ID][12]);
      end
      else
      begin
        tile.Canvas.Draw(0, 0, tileArr[ID][4]);
      end;
    end
  else
  begin
      if terrain[x-1][y]=targedId then
      begin
        tile.Canvas.Draw(0, 0, tileArr[ID][3]);
      end
      else
      begin
        if terrain[x-1][y-1]=targedId then
          tile.Canvas.Draw(0, 0, tileArr[ID][10])
        else
          tile.Canvas.Draw(0, 0, tileArr[ID][1])
      end;
    end;

  //Oben-Rechts
  if terrain[x][y-1]=targedId then
  begin
    if terrain[x+1][y]=targedId then
    begin
      tile.Canvas.Draw(16, 0, tileArr[ID][13]);
    end
    else
    begin
      tile.Canvas.Draw(16, 0, tileArr[ID][4]);
    end;
  end
  else
  begin
      if terrain[x+1][y]=targedId then
      begin
        tile.Canvas.Draw(16, 0, tileArr[ID][5]);
      end
      else
      begin
        if terrain[x+1][y-1]=targedId then
          tile.Canvas.Draw(16, 0, tileArr[ID][7])
        else
          tile.Canvas.Draw(16, 0, tileArr[ID][1])
      end;
    end;

  //Unten-Links
  if terrain[x][y+1]=targedId then
  begin
      if terrain[x-1][y]=targedId then
      begin
        tile.Canvas.Draw(0, 16, tileArr[ID][11]);
      end
      else
      begin
        tile.Canvas.Draw(0, 16, tileArr[ID][6]);
      end;
    end
  else
  begin
      if terrain[x-1][y]=targedId then
      begin
        tile.Canvas.Draw(0, 16, tileArr[ID][3]);
      end
      else
      begin
        if terrain[x-1][y+1]=targedId then
          tile.Canvas.Draw(0, 16, tileArr[ID][9])
        else
          tile.Canvas.Draw(0, 16, tileArr[ID][2])
      end;
    end;

  //Unten-Rechts
  if terrain[x][y+1]=targedId then
  begin
      if terrain[x+1][y]=targedId then
      begin
        tile.Canvas.Draw(16, 16, tileArr[ID][14]);
      end
      else
      begin
        tile.Canvas.Draw(16, 16, tileArr[ID][6]);
      end;
    end
  else
  begin
    if terrain[x+1][y]=targedId then
    begin
      tile.Canvas.Draw(16, 16, tileArr[ID][5]);
    end
    else
    begin
      if terrain[x+1][y+1]=targedId then
        tile.Canvas.Draw(16, 16, tileArr[ID][8])
      else
        tile.Canvas.Draw(16, 16, tileArr[ID][2])
    end;
  end;

  BuildAutoTileTerrain:=tile;
end;

function AutoTile4Sides(x, y, ID:Integer; isBuilding : Boolean): TBitmap;
var i : Integer;
begin
  // Die 4 Siten (Up, Left, Right, Down) werden als Binärzahl dergestellt um alle möglichkeiten durchzugehen
  //     a
  //    b#c             abcd
  //     d              0110 --> Tile 6
  // Die Dateipositionen können durch die binarzahl somit auch direkt ermittelt werden
  tile.Canvas.Clear;
  i:=0;

  // Für Gebäude
  if (isBuilding) then
  begin
    if (buildings[x][y-1].id=ID) and (y>0) then
      i+=8;

    if (buildings[x-1][y].id=ID) and (x>0) then
      i+=4;

    if (buildings[x+1][y].id=ID) and (x<mapWidth-1) then
      i+=2;

    if (buildings[x][y+1].id=ID) and (y<mapHeight-1)then
      i+=1;
  end
  else

  // Für die Landschaft (Hintergrund)
  begin
    if (terrain[x][y-1]=ID) and (y>0) then
      i+=8;

    if (terrain[x-1][y]=ID) and (x>0) then
      i+=4;

    if (terrain[x+1][y]=ID) and (x<mapWidth-1) then
      i+=2;

    if (terrain[x][y+1]=ID) and (y<mapHeight-1)then
      i+=1;
  end;


  AutoTile4Sides:=tileArr[ID][i]
end;

function FormCoordsToTile(x,y :Integer):TPoint;
begin
  result:=TPoint.Create(Floor(x/32),Floor(y/32));
end;

function GetTileBitmap(x, y: Integer):TBitmap;
var tile:TBitmap;
begin
  tile:=TBitmap.Create;
  // falls Autotiles vorhanden werden diese erstellt
  if buildings[x][y].id < 3 then
  begin
    case terrain[x][y] of
      // Wasser
      0:
        tile:=BuildAutoTileTerrain(x, y, 0, 1);

      // Grass
      1:
        tile:=tileArr[1][0];

      // Dirt
      2:
        tile:=tileArr[2][0];
    end;
  end
  else
  begin
    case buildings[x][y].id of
      3:
        tile:=tileArr[3][buildings[x][y].level];
      4:
        tile:=tileArr[4][buildings[x][y].level];
      5:
        tile:=tileArr[5][buildings[x][y].level];
      6:
        tile:=AutoTile4Sides(x, y, 6, true);
      7:
        tile:=AutoTile4Sides(x, y, 7, true);
      8:
        tile:=AutoTile4Sides(x, y, 8, true);
      9:
        tile:=AutoTile4Sides(x, y, 9, true);
      10:
        tile:=AutoTile4Sides(x, y, 10, true);
      11:
        tile:=tileArr[11][0];
      12:
        tile:=GetMultiTileBitmap(x, y, 2, 2);
      13:
        tile:=GetMultiTileBitmap(x, y, 2, 2);
      14:
        tile:=GetMultiTileBitmap(x, y, 2, 2);
      15:
        tile:=GetMultiTileBitmap(x, y, 3, 2);
      16:
        tile:=tileArr[16][0];
      17:
        tile:=GetMultiTileBitmap(x, y, 2, 2);
      18:
        tile:=tileArr[0][0];
      19:
        tile:=tileArr[0][0];
      20:
        tile:=tileArr[20][0];
      21:
        tile:=GetMultiTileBitmap(x, y, 2, 2);
      22:
        tile:=GetMultiTileBitmap(x, y, 3, 3);
      23:
        tile:=GetMultiTileBitmap(x, y, 4, 4);
      24:
        tile:=tileArr[24][0];
      25:
        tile:=GetMultiTileBitmap(x, y, 2, 2);
      26:
        tile:=GetMultiTileBitmap(x, y, 3, 3);
      27:
        tile:=GetMultiTileBitmap(x, y, 4, 4);
      28:
        tile:=tileArr[28][0];
      29:
        tile:=GetMultiTileBitmap(x, y, 2, 2);
      30:
        tile:=GetMultiTileBitmap(x, y, 3, 3);
      31:
        tile:=GetMultiTileBitmap(x, y, 4, 4);
      32:
        tile:=tileArr[32][0];
      33:
        tile:=GetMultiTileBitmap(x, y, 2, 2);
      34:
        tile:=GetMultiTileBitmap(x, y, 3, 3);
      35:
        tile:=GetMultiTileBitmap(x, y, 4, 4);
      36:
        tile:=tileArr[36][0];
      37:
        tile:=tileArr[37][0];
      38:
        tile:=GetMultiTileBitmap(x, y, 2, 2);
      39:
        tile:=GetMultiTileBitmap(x, y, 4, 3);
      40:
        tile:=tileArr[40][0];
    end;
  end;

  GetTileBitmap:=tile;
end;

function IsBuildingPlacable(tileX, tileY, width, height:Integer):Boolean;
var x, y:Integer;
begin
  // Wird am anfang true gesetzt
  IsBuildingPlacable:=true;
  for x:=0 to width-1 do
  begin
    for y:=0 to height-1 do
    begin
      // Innerhalb der baufläche ein gebäude erkannt wird, wird false returned
      if (buildings[tilex+x][tiley+y].id<>0) then
        IsBuildingPlacable:=false;
    end;
  end;
end;

procedure PlaceMultiTile(tileX, tileY, width, height, id: Integer);
var x, y : Integer;
begin
  for x:=0 to width-1 do
  begin
    for y:=0 to height-1 do
    begin
      buildings[tilex+x][tiley+y].id:=id;
      if (x=0) and (y=0) then
      begin
        buildings[tilex+x][tiley+y].isParentTile:=true;
      end
      else
    end;
  end;
end;

procedure DestroyMultiTile(tileX, tileY, width, height: Integer);
var x, y : Integer;
  parentPos:TPoint;
begin
  parentPos:=GetParentTilePosition(tilex, tiley, width, height);
  for x:=0 to width-1 do
  begin
    for y:=0 to height-1 do
    begin
      buildings[parentpos.X+x][parentPos.Y+y].id:=0;
      buildings[parentpos.X+x][parentPos.Y+y].isParentTile:=false;
    end;
  end;
end;

procedure PlaceBuildingTile(x, y, id : Integer);
begin

  case id of
    12:
      begin
      if (IsBuildingPlacable(x, y, 2, 2)) then
        PlaceMultiTile(x, y, 2, 2, 12);
      end;
    13:
      begin
      if (IsBuildingPlacable(x, y, 2, 2)) then
        PlaceMultiTile(x, y, 2, 2, 13);
      end;
    14:
      begin
      if (IsBuildingPlacable(x, y, 2, 2)) then
        PlaceMultiTile(x, y, 2, 2, 14);
      end;
    15:
      begin
      if (IsBuildingPlacable(x, y, 3, 2)) then
        PlaceMultiTile(x, y, 3, 2, 15);
      end;
    17:
      begin
      if (IsBuildingPlacable(x, y, 2, 2)) then
        PlaceMultiTile(x, y, 2, 2, 17);
      end;
    21:
      begin
      if (IsBuildingPlacable(x, y, 2, 2)) then
        PlaceMultiTile(x, y, 2, 2, 21);
      end;
    22:
      begin
      if (IsBuildingPlacable(x, y, 3, 3)) then
        PlaceMultiTile(x, y, 3, 3, 22);
      end;
    23:
      begin
      if (IsBuildingPlacable(x, y, 4, 4)) then
        PlaceMultiTile(x, y, 4, 4, 23);
      end;
    25:
      begin
      if (IsBuildingPlacable(x, y, 2, 2)) then
        PlaceMultiTile(x, y, 2, 2, 25);
      end;
    26:
      begin
      if (IsBuildingPlacable(x, y, 3, 3)) then
        PlaceMultiTile(x, y, 3, 3, 26);
      end;
    27:
      begin
      if (IsBuildingPlacable(x, y, 4, 4)) then
        PlaceMultiTile(x, y, 4, 4, 27);
      end;
    29:
      begin
      if (IsBuildingPlacable(x, y, 2, 2)) then
        PlaceMultiTile(x, y, 2, 2, 29);
      end;
    30:
      begin
      if (IsBuildingPlacable(x, y, 3, 3)) then
        PlaceMultiTile(x, y, 3, 3, 30);
      end;
    31:
      begin
      if (IsBuildingPlacable(x, y, 4, 4)) then
        PlaceMultiTile(x, y, 4, 4, 31);
      end;
    33:
      begin
      if (IsBuildingPlacable(x, y, 2, 2)) then
        PlaceMultiTile(x, y, 2, 2, 33);
      end;
    34:
      begin
      if (IsBuildingPlacable(x, y, 3, 3)) then
        PlaceMultiTile(x, y, 3, 3, 34);
      end;
    35:
      begin
      if (IsBuildingPlacable(x, y, 4, 4)) then
        PlaceMultiTile(x, y, 4, 4, 35);
      end;
    38:
      begin
      if (IsBuildingPlacable(x, y, 2, 2)) then
        PlaceMultiTile(x, y, 2, 2, 38);
      end;
    39:
      begin
      if (IsBuildingPlacable(x, y, 4, 3)) then
        PlaceMultiTile(x, y, 4, 3, 39);
      end;
    else
      begin
        if (IsBuildingPlacable(x, y, 1, 1)) then
        begin
          buildings[x][y].id:=id;
        end;
      end;
  end;
end;

function GetMinimapColor(id:Integer):TColor;
begin
  case id of
    0:
      GetMinimapColor:=RGBToColor(0, 153, 219);
    1:
      GetMinimapColor:=RGBToColor(62, 137, 72);
    2:
      GetMinimapColor:=RGBToColor(184, 111, 80);
    3:
      GetMinimapColor:=RGBToColor(0, 200, 0);
    4:
      GetMinimapColor:=RGBToColor(0, 0, 200);
    5:
      GetMinimapColor:=RGBToColor(0, 250, 250);
    7:
      GetMinimapColor:=RGBToColor(200, 200, 200);
    8:
      GetMinimapColor:=RGBToColor(255, 255, 255);
    9:
      GetMinimapColor:=RGBToColor(137, 10, 241);
    10:
      GetMinimapColor:=RGBToColor(0, 255, 255);
    11:
      GetMinimapColor:=RGBToColor(0, 255, 255);
    12:
      GetMinimapColor:=RGBToColor(0, 255, 255);
    13:
      GetMinimapColor:=RGBToColor(0, 255, 255);
    14:
      GetMinimapColor:=RGBToColor(0, 255, 255);
    15:
      GetMinimapColor:=RGBToColor(0, 255, 255);
    16:
      GetMinimapColor:=RGBToColor(0, 255, 255);
    17:
      GetMinimapColor:=RGBToColor(0, 255, 255);
    18:
      GetMinimapColor:=RGBToColor(0, 255, 255);
    19:
      GetMinimapColor:=RGBToColor(0, 255, 255);
    20:
      GetMinimapColor:=RGBToColor(0, 255, 255);
    21:
      GetMinimapColor:=RGBToColor(0, 255, 255);
    22:
      GetMinimapColor:=RGBToColor(0, 255, 255);
    23:
      GetMinimapColor:=RGBToColor(0, 255, 255);
    24:
      GetMinimapColor:=RGBToColor(0, 255, 255);
    25:
      GetMinimapColor:=RGBToColor(0, 255, 255);
    26:
      GetMinimapColor:=RGBToColor(0, 255, 255);
    27:
      GetMinimapColor:=RGBToColor(0, 255, 255);
    28:
      GetMinimapColor:=RGBToColor(0, 255, 255);
    29:
      GetMinimapColor:=RGBToColor(0, 255, 255);
    30:
      GetMinimapColor:=RGBToColor(0, 255, 255);
    31:
      GetMinimapColor:=RGBToColor(0, 255, 255);
    32:
      GetMinimapColor:=RGBToColor(0, 255, 255);
    33:
      GetMinimapColor:=RGBToColor(0, 255, 255);
    34:
      GetMinimapColor:=RGBToColor(0, 255, 255);
    35:
      GetMinimapColor:=RGBToColor(0, 255, 255);
    36:
      GetMinimapColor:=RGBToColor(0, 255, 255);
    37:
      GetMinimapColor:=RGBToColor(0, 255, 255);
    38:
      GetMinimapColor:=RGBToColor(0, 255, 255);
    39:
      GetMinimapColor:=RGBToColor(0, 255, 255);
    40:
      GetMinimapColor:=RGBToColor(0, 255, 255);
  end;
end;

procedure DestroyBuildingTile(x, y: Integer);
var id : Integer;
begin
  id:=buildings[x][y].id;
  begin
    case id of
      12:
         DestroyMultiTile(x, y, 2, 2);
      13:
         DestroyMultiTile(x, y, 2, 2);
      14:
         DestroyMultiTile(x, y, 2, 2);
      15:
         DestroyMultiTile(x, y, 3, 2);
      17:
         DestroyMultiTile(x, y, 2, 2);
      21:
         DestroyMultiTile(x, y, 2, 2);
      22:
         DestroyMultiTile(x, y, 3, 3);
      23:
         DestroyMultiTile(x, y, 4, 4);
      25:
         DestroyMultiTile(x, y, 2, 2);
      26:
         DestroyMultiTile(x, y, 3, 3);
      27:
         DestroyMultiTile(x, y, 4, 4);
      29:
         DestroyMultiTile(x, y, 2, 2);
      30:
         DestroyMultiTile(x, y, 3, 3);
      31:
         DestroyMultiTile(x, y, 4, 4);
      33:
         DestroyMultiTile(x, y, 2, 2);
      34:
         DestroyMultiTile(x, y, 3, 3);
      35:
         DestroyMultiTile(x, y, 4, 4);
      38:
         DestroyMultiTile(x, y, 2, 2);
      39:
         DestroyMultiTile(x, y, 4, 3);
      else
        buildings[x][y].id:=0;
    end;
  end;
end;
procedure LoadTiles();
var i: Integer;
begin

  // Initialise Tile TBitmap
  tile:=TBitmap.Create;
  tile.Height:=32;
  tile.Width:=32;

  // Wasser
  tileArr[0][0]:=TBitmap.Create;
  tileArr[0][0].LoadFromFile('gfx/tiles/0/0.bmp');
  tileArr[0][1]:=TBitmap.Create;
  tileArr[0][1].LoadFromFile('gfx/tiles/0/0_0-0.bmp');
  tileArr[0][2]:=TBitmap.Create;
  tileArr[0][2].LoadFromFile('gfx/tiles/0/0_0-1.bmp');
  for i:=0 to 11 do
  begin
    tileArr[0][i+3]:=TBitmap.Create;
    tileArr[0][i+3].LoadFromFile('gfx/tiles/0/0_1-'+IntToStr(i)+'.bmp');
  end;

  // Gras
  tileArr[1][0]:=TBitmap.Create;
  tileArr[1][0].LoadFromFile('gfx/tiles/1/1.bmp');

  // Dirt
  tileArr[2][0]:=TBitmap.Create;
  tileArr[2][0].LoadFromFile('gfx/tiles/2/2.bmp');

  // Wohnungen
  for i:=0 to 4 do
  begin
    tileArr[3][i]:=TBitmap.Create;
    tileArr[3][i].LoadFromFile('gfx/tiles/3/3_'+IntToStr(i)+'.bmp');
  end;

  // Gewerbe
  for i:=0 to 4 do
  begin
    tileArr[4][i]:=TBitmap.Create;
    tileArr[4][i].LoadFromFile('gfx/tiles/4/4_'+IntToStr(i)+'.bmp');
  end;

  // Industrie
  for i:=0 to 4 do
  begin
    tileArr[5][i]:=TBitmap.Create;
    tileArr[5][i].LoadFromFile('gfx/tiles/5/5_'+IntToStr(i)+'.bmp');
  end;

  // Feldweg
  for i:=0 to 15 do
  begin
    tileArr[6][i]:=TBitmap.Create;
    tileArr[6][i].LoadFromFile('gfx/tiles/6/6_6-'+IntToStr(i)+'.bmp');
  end;
  // Landstraße 2-Spuren
  for i:=0 to 15 do
  begin
    tileArr[7][i]:=TBitmap.Create;
    tileArr[7][i].LoadFromFile('gfx/tiles/7/7_7-'+IntToStr(i)+'.bmp');
  end;
end;
initialization
begin
  mapHeight:=288;
  mapWIdth:=288;
  LoadTiles();
  screenHeight:=30;
  screenWidth:=49;
  SetLength(terrain, mapHeight, mapWidth);
  SetLength(buildings, mapHeight, mapWidth);
end;
end.


