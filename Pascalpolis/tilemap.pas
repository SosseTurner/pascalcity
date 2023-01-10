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
  tileArr: array[0..6] of array[0..20] of TBitmap;
  screenWidth, screenHeight:  Integer;
  offsetX, offsetY : Integer;
  mapWidth, mapHeight: Integer;
  tile: TBitmap;

function FormCoordsToTile(x,y :Integer):TPoint;
function GetTile(x, y: Integer):TBitmap;
procedure LoadTiles();
procedure GenerateMap();
procedure DestroyMultiTile2x2(x, y : Integer);

implementation

// World Generation durch Cellular Automate
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

function MultiTile2x2(x, y, Id: Integer):TBitmap;
begin
  // Die oberen drei (Eck)tiles werden auf .isParent überprüft
  // je nachdem welche welches Tile es ist wird das sprite ausgesucht.
  // Bsp.: Die Tiles a,b,c sind die (Eck)Tiles   ab
  //                                             c#
   if (buildings[x-1][y-1].isParentTile) then
     multiTile2x2:=tileArr[id][3]
   else if (buildings[x][y-1].isParentTile) then
     multiTile2x2:=tileArr[id][2]
   else if (buildings[x-1][y].isParentTile) then
     multiTile2x2:=tileArr[id][1]
   else
     multiTile2x2:=tileArr[id][0];
end;

procedure DestroyMultiTile2x2(x, y : Integer);
var id : Integer;
begin
  id:=buildings[x][y].id;
  // Löscht ein 2x2 Tile
  // falls unten Link
   if (buildings[x-1][y-1].isParentTile) and (buildings[x-1][y-1].id=id)then
     begin
       buildings[x-1][y-1].id:=0;
       buildings[x][y-1].id:=0;
       buildings[x-1][y].id:=0;
       buildings[x][y].id:=0;
     end
   else if (buildings[x][y-1].isParentTile) and (buildings[x][y-1].id=id) then
     begin
       buildings[x][y-1].id:=0;
       buildings[x][y].id:=0;
       buildings[x+1][y-1].id:=0;
       buildings[x+1][y].id:=0;
     end
   else if (buildings[x-1][y].isParentTile) and (buildings[x-1][y].id=id) then
     begin
       buildings[x][y].id:=0;
       buildings[x-1][y].id:=0;
       buildings[x][y+1].id:=0;
       buildings[x-1][y+1].id:=0;
     end
   else
     begin
       buildings[x][y].id:=0;
       buildings[x+1][y].id:=0;
       buildings[x][y+1].id:=0;
       buildings[x+1][y+1].id:=0;
     end
end;

function BuildAutoTile(x, y, ID: Integer):TBitmap;
begin
  // Die Tiles werden durch 4 einzelne Stücken zusammengesetzt
  // Nur zwischen Wasser(0) und Land(1) möglich
  // Refactoring nötig um zwischen mehren Tiles zu unterscheiden
  tile.Canvas.Clear;

  // Oben Links
  if terrain[x][y-1]=1 then
  begin
      if terrain[x-1][y]=1 then
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
      if terrain[x-1][y]=1 then
      begin
        tile.Canvas.Draw(0, 0, tileArr[ID][3]);
      end
      else
      begin
        if terrain[x-1][y-1]=1 then
          tile.Canvas.Draw(0, 0, tileArr[ID][10])
        else
          tile.Canvas.Draw(0, 0, tileArr[ID][1])
      end;
    end;

  //Oben-Rechts
  if terrain[x][y-1]=1 then
  begin
    if terrain[x+1][y]=1 then
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
      if terrain[x+1][y]=1 then
      begin
        tile.Canvas.Draw(16, 0, tileArr[ID][5]);
      end
      else
      begin
        if terrain[x+1][y-1]=1 then
          tile.Canvas.Draw(16, 0, tileArr[ID][7])
        else
          tile.Canvas.Draw(16, 0, tileArr[ID][1])
      end;
    end;

  //Unten-Links
  if terrain[x][y+1]=1 then
  begin
      if terrain[x-1][y]=1 then
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
      if terrain[x-1][y]=1 then
      begin
        tile.Canvas.Draw(0, 16, tileArr[ID][3]);
      end
      else
      begin
        if terrain[x-1][y+1]=1 then
          tile.Canvas.Draw(0, 16, tileArr[ID][9])
        else
          tile.Canvas.Draw(0, 16, tileArr[ID][2])
      end;
    end;

  //Unten-Rechts
  if terrain[x][y+1]=1 then
  begin
      if terrain[x+1][y]=1 then
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
    if terrain[x+1][y]=1 then
    begin
      tile.Canvas.Draw(16, 16, tileArr[ID][5]);
    end
    else
    begin
      if terrain[x+1][y+1]=1 then
        tile.Canvas.Draw(16, 16, tileArr[ID][8])
      else
        tile.Canvas.Draw(16, 16, tileArr[ID][2])
    end;
  end;

  BuildAutoTile:=tile;
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

function GetTile(x, y: Integer):TBitmap;
var tile:TBitmap;
begin
  tile:=TBitmap.Create;
  // falls Autotiles vorhanden werden diese erstellt
  if buildings[x][y].id < 3 then
  begin
    case terrain[x][y] of
      // Wasser
      0:
        tile:=BuildAutoTile(x, y, 0);

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
      // Straße
      3:
        tile:=AutoTile4Sides(x, y, 3, true);
      // Haus
      4:
        tile:=tileArr[4][0];
      6:
        tile:=multiTile2x2(x,y,6);
    end;
  end;

  GetTile:=tile;
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

  // Straße
  for i:=0 to 15 do
  begin
    tileArr[3][i]:=TBitmap.Create;
    tileArr[3][i].LoadFromFile('gfx/tiles/3/3_3-'+IntToStr(i)+'.bmp');
  end;

  // Haus
  tileArr[4][0]:=TBitmap.Create;
  tileArr[4][0].LoadFromFile('gfx/tiles/4/4.bmp');

  // Haus 2x2
  for i:=0 to 3 do
  begin
    tileArr[6][i]:=TBitmap.Create;
    tileArr[6][i].LoadFromFile('gfx/tiles/6/6_6-'+IntToStr(i)+'.bmp');
  end;
end;
initialization
begin
  mapHeight:=300;
  mapWIdth:=300;
  LoadTiles();
  screenHeight:=30;
  screenWidth:=50;
  SetLength(terrain, mapHeight, mapWidth);
  SetLength(buildings, mapHeight, mapWidth);
end;
end.


