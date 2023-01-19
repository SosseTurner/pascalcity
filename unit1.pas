unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Arrow, ComCtrls, Spin, LazLogger,
  Tilemap;

type

  { TForm1 }

  TForm1 = class(TForm)
    Arrow1: TArrow;
    Arrow2: TArrow;
    Arrow3: TArrow;
    Arrow4: TArrow;
    Button1: TButton;
    Image1: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Image14: TImage;
    Image15: TImage;
    Image16: TImage;
    Image17: TImage;
    Image18: TImage;
    Image19: TImage;
    Image2: TImage;
    Image20: TImage;
    Image21: TImage;
    Image22: TImage;
    Image23: TImage;
    Image24: TImage;
    Image25: TImage;
    Image26: TImage;
    Image27: TImage;
    Image28: TImage;
    Image29: TImage;
    Image3: TImage;
    Image30: TImage;
    Image31: TImage;
    Image32: TImage;
    Image33: TImage;
    Image34: TImage;
    Image35: TImage;
    Image36: TImage;
    Image37: TImage;
    Image38: TImage;
    Image39: TImage;
    Image4: TImage;
    Image40: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    PageControl1: TPageControl;
    SpinEdit1: TSpinEdit;
    TabSheet1: TTabSheet;
    TabSheet10: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    TabSheet9: TTabSheet;
    ToggleBox1: TToggleBox;
    ToggleBox2: TToggleBox;
    procedure Arrow1Click(Sender: TObject);
    procedure Arrow2Click(Sender: TObject);
    procedure Arrow3Click(Sender: TObject);
    procedure Arrow4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure SetUpGui();
begin
  // Ist notwendig da bei verschieden Monitoren sich die Gui-Elemente verschoben haben

  // Start
  Form1.Button1.Visible:=false;

  // Bauen
  Form1.ToggleBox1.Left:=1600;
  Form1.ToggleBox1.Top:=364;
  Form1.ToggleBox1.Height:=64;
  Form1.ToggleBox1.Width:=64;
  Form1.ToggleBox1.Visible:=true;

  // Abreisen
  Form1.ToggleBox2.Left:=1664;
  Form1.ToggleBox2.Top:=364;
  Form1.ToggleBox2.Height:=64;
  Form1.ToggleBox2.Width:=64;
  Form1.ToggleBox2.Visible:=true;

  // Navigations-Pfeile

     // Westen
     Form1.Arrow1.Left:=1568;
     Form1.Arrow1.Top:=Round(mapHeight/2)+16;
     Form1.Arrow1.Height:=32;
     Form1.Arrow1.Width:=32;

     // Norden
     Form1.Arrow2.Left:=1568+Round(mapWidth/2)+16;
     Form1.Arrow2.Top:=0;
     Form1.Arrow2.Height:=32;
     Form1.Arrow2.Width:=32;

     // Osten
     Form1.Arrow4.Left:=1568+mapWidth+32;
     Form1.Arrow4.Top:=Round(mapHeight/2)+16;
     Form1.Arrow4.Height:=32;
     Form1.Arrow4.Width:=32;

     // Süden
     Form1.Arrow3.Left:=1568+Round(mapWidth/2)+16;
     Form1.Arrow3.Top:=mapHeight+32;
     Form1.Arrow3.Height:=32;
     Form1.Arrow3.Width:=32;

  // BauMenu
  Form1.PageControl1.Left:=1568;
  Form1.PageControl1.Top:=428;
  Form1.PageControl1.Width:=352;
  Form1.PageControl1.Height:=320;

    //Straßen
      // Feldweg
      Form1.Image3.Width:=32;
      Form1.Image3.Height:=32;
      Form1.Image3.Left:=0;
      Form1.Image3.Top:=0;


      // Landstraße 2-Spuren
      Form1.Image1.Width:=32;
      Form1.Image1.Height:=32;
      Form1.Image1.Left:=32;
      Form1.Image1.Top:=0;

      // Allee
      Form1.Image4.Width:=32;
      Form1.Image4.Height:=32;
      Form1.Image4.Left:=64;
      Form1.Image4.Top:=0;

      // Landstraße 4-Spuren
      Form1.Image5.Width:=32;
      Form1.Image5.Height:=32;
      Form1.Image5.Left:=96;
      Form1.Image5.Top:=0;

      // Schnellstraße
      Form1.Image6.Width:=32;
      Form1.Image6.Height:=32;
      Form1.Image6.Left:=128;
      Form1.Image6.Top:=0;

    // Strom
      // Solar klein
      Form1.Image7.Width:=32;
      Form1.Image7.Height:=32;
      Form1.Image7.Left:=0;
      Form1.Image7.Top:=0;

      // Solar Groß
      Form1.Image2.Width:=64;
      Form1.Image2.Height:=64;
      Form1.Image2.Left:=32;
      Form1.Image2.Top:=0;

      // Wasserkraftwerk
      Form1.Image8.Width:=64;
      Form1.Image8.Height:=64;
      Form1.Image8.Left:=96;
      Form1.Image8.Top:=0;

      // Kohlekraftwerk
      Form1.Image9.Width:=64;
      Form1.Image9.Height:=64;
      Form1.Image9.Left:=160;
      Form1.Image9.Top:=0;

      // Atomkraftwerk
      Form1.Image10.Width:=96;
      Form1.Image10.Height:=96;
      Form1.Image10.Left:=0;
      Form1.Image10.Top:=64;

    // Feuerwehr
      // Feuerwache klein
      Form1.Image11.Width:=32;
      Form1.Image11.Height:=32;
      Form1.Image11.Left:=0;
      Form1.Image11.Top:=0;

      // Feuerwache groß
      Form1.Image12.Width:=64;
      Form1.Image12.Height:=64;
      Form1.Image12.Left:=32;
      Form1.Image12.Top:=0;

      // Löschhubschrauberlandeplatz
      Form1.Image13.Width:=96;
      Form1.Image13.Height:=96;
      Form1.Image13.Left:=0;
      Form1.Image13.Top:=64;

      // Feuerwehrzentrale
      Form1.Image14.Width:=128;
      Form1.Image14.Height:=128;
      Form1.Image14.Left:=96;
      Form1.Image14.Top:=0;

    // Polizei
      // Polizeiwache klein
      Form1.Image15.Width:=32;
      Form1.Image15.Height:=32;
      Form1.Image15.Left:=0;
      Form1.Image15.Top:=0;

      // Polizeiwache groß
      Form1.Image16.Width:=64;
      Form1.Image16.Height:=64;
      Form1.Image16.Left:=32;
      Form1.Image16.Top:=0;

      // Polizeizentrale
      Form1.Image18.Width:=96;
      Form1.Image18.Height:=96;
      Form1.Image18.Left:=0;
      Form1.Image18.Top:=64;

      // Gefängnis
      Form1.Image17.Width:=128;
      Form1.Image17.Height:=128;
      Form1.Image17.Left:=96;
      Form1.Image17.Top:=0;

    // Gesundheit
        // Arztpraxis klein
      Form1.Image19.Width:=32;
      Form1.Image19.Height:=32;
      Form1.Image19.Left:=0;
      Form1.Image19.Top:=0;

      // Arztpraxis groß
      Form1.Image20.Width:=64;
      Form1.Image20.Height:=64;
      Form1.Image20.Left:=32;
      Form1.Image20.Top:=0;

      // Krankenhaus
      Form1.Image22.Width:=96;
      Form1.Image22.Height:=96;
      Form1.Image22.Left:=0;
      Form1.Image22.Top:=64;

      // Medizinisches Zentrum
      Form1.Image21.Width:=128;
      Form1.Image21.Height:=128;
      Form1.Image21.Left:=96;
      Form1.Image21.Top:=0;
    // Wasser
      // Wasserturm klein
      Form1.Image24.Width:=32;
      Form1.Image24.Height:=32;
      Form1.Image24.Left:=0;
      Form1.Image24.Top:=0;

      // Wasserturm groß
      Form1.Image23.Width:=64;
      Form1.Image23.Height:=64;
      Form1.Image23.Left:=32;
      Form1.Image23.Top:=0;

      // Wasserpumpe horizontal
      Form1.Image27.Width:=64;
      Form1.Image27.Height:=32;
      Form1.Image27.Left:=96;
      Form1.Image27.Top:=0;

      // Wasserpumpe vertikal
      Form1.Image28.Width:=32;
      Form1.Image28.Height:=64;
      Form1.Image28.Left:=160;
      Form1.Image28.Top:=0;

      // Staudamm vertikal
      Form1.Image26.Width:=32;
      Form1.Image26.Height:=128;
      Form1.Image26.Left:=192;
      Form1.Image26.Top:=0;

      // Staudamm horizontal
      Form1.Image25.Width:=128;
      Form1.Image25.Height:=32;
      Form1.Image25.Left:=64;
      Form1.Image25.Top:=64;

    // Bildung
      // Kindergarten
      Form1.Image29.Width:=32;
      Form1.Image29.Height:=32;
      Form1.Image29.Left:=0;
      Form1.Image29.Top:=0;

      // Schule
      Form1.Image30.Width:=64;
      Form1.Image30.Height:=64;
      Form1.Image30.Left:=32;
      Form1.Image30.Top:=0;

      // Oberschule
      Form1.Image32.Width:=96;
      Form1.Image32.Height:=96;
      Form1.Image32.Left:=0;
      Form1.Image32.Top:=64;

      // Universität
      Form1.Image31.Width:=128;
      Form1.Image31.Height:=128;
      Form1.Image31.Left:=96;
      Form1.Image31.Top:=0;

    // Freizeit
      // Park
      Form1.Image33.Width:=32;
      Form1.Image33.Height:=32;
      Form1.Image33.Left:=0;
      Form1.Image33.Top:=0;

      // Theater
      Form1.Image34.Width:=32;
      Form1.Image34.Height:=32;
      Form1.Image34.Left:=32;
      Form1.Image34.Top:=0;

      // Kino
      Form1.Image35.Width:=64;
      Form1.Image35.Height:=64;
      Form1.Image35.Left:=64;
      Form1.Image35.Top:=0;

      // Stadion
      Form1.Image36.Width:=128;
      Form1.Image36.Height:=96;
      Form1.Image36.Left:=128;
      Form1.Image36.Top:=0;

    // Dekoration
      // Pinoraurier Statue
      Form1.Image37.Width:=32;
      Form1.Image37.Height:=32;
      Form1.Image37.Left:=0;
      Form1.Image37.Top:=0;

    // Zonen
      // Wohngebiet
      Form1.Image38.Width:=32;
      Form1.Image38.Height:=32;
      Form1.Image38.Left:=0;
      Form1.Image38.Top:=0;

      // Gewebegebiet
      Form1.Image38.Width:=32;
      Form1.Image38.Height:=32;
      Form1.Image38.Left:=32;
      Form1.Image38.Top:=0;

      // Industriegebiet
      Form1.Image38.Width:=32;
      Form1.Image38.Height:=32;
      Form1.Image38.Left:=64;
      Form1.Image38.Top:=0;

  // Tile Select (Temperär)
  Form1.SpinEdit1.Left:=1728;
  Form1.SpinEdit1.Top:=364;
  Form1.SpinEdit1.Height:=64;
  Form1.SpinEdit1.Width:=128;
  Form1.SpinEdit1.MaxValue:=19;
  Form1.SpinEdit1.MinValue:=3;
end;

procedure DrawMinimap();
var x, y : Integer;
  bmp: TBitmap;
begin
  // Die Minimap wird Pixel für Pixel neu, anhand der Gebäudefarbe ertstellt

  bmp:=TBitmap.Create;
  bmp.Height:=mapHeight;
  bmp.Width:=mapWidth;
  for x:=0 to mapWidth-1 do
  begin
    for y:=0 to mapHeight-1 do
    begin
      if buildings[x][y].id<3 then
        bmp.Canvas.Pixels[x, y]:=GetMinimapColor(terrain[x][y])
      else
        bmp.Canvas.Pixels[x, y]:=GetMinimapColor(buildings[x][y].id)
    end;
  end;
  Form1.Canvas.Draw(32*screenWidth+32, 32, bmp);


  // Der Sichtbare bereich wird durch umrandung kenntlich gemacht
  Form1.Canvas.Line((offsetX+32*screenWidth)+32, offsetY+32, (32+offsetX+screenWidth)+32*screenWidth, offsetY+32);
  Form1.Canvas.Line((offsetX+32*screenWidth)+32, offsetY+32, (offsetX+32*screenWidth)+32, offsetY+screenHeight+32);
  Form1.Canvas.Line((offsetX+32*screenWidth)+screenWidth+32, offsetY+32, (32+offsetX+screenWidth)+32*screenWidth, offsetY+screenHeight+32);
  Form1.Canvas.Line((offsetX+32*screenWidth)+32, offsetY+screenHeight+32, (32+offsetX+screenWidth)+32*screenWidth, offsetY+screenHeight+32);
end;

procedure UpdateMinimapTile(tileX, tileY : Integer);
var x, y : Integer;
  bmp: TBitmap;
begin
  // Die Minimap wird Pixel für Pixel neu, anhand der Gebäudefarbe ertstellt

  bmp:=TBitmap.Create;
  bmp.Height:=mapHeight;
  bmp.Width:=mapWidth;
  for x:=tileX-1 to tileX+1 do
  begin
    for y:=tileY-1 to tileY+1 do
    begin

      // Falls nach einer Koordinate außerhalb des Arrays gefragt wird
      if (x>=0) or (x<=screenWidth-1) or (y>=0) or (y<=screenHeight-1)then
      begin
        if (buildings[x][y].id<3) then
          Form1.Canvas.Pixels[32*screenWidth+x+32, y+32]:=GetMinimapColor(terrain[x][y])
        else
          Form1.Canvas.Pixels[32*screenWidth+x+32, y+32]:=GetMinimapColor(buildings[x][y].id)
      end;
    end;
  end;
end;

procedure DrawMap();
var x, y : Integer;
    bmp: TBitmap;
begin
  // Initialisieren einer neuen Bitmap
  // Diese wird benutzt um die Tiles auf die Form zu malen
  bmp:=TBitmap.Create;
  bmp.Height:=screenHeight*32;
  bmp.Width:=screenWidth*32;

  // Jedes Sichtbare Tile wird gesammtelt und zu einem Bild zusammengesetzt
  for x:=0 to screenWidth-1 do
  begin
    for y:=0 to screenHeight-1 do
    begin
      bmp.Canvas.Draw(x*32, y*32, Tilemap.GetTileBitmap(x+offsetX, y+offsetY));
    end;
  end;

  // Die Tiles werden auf das Form gemalt
  Form1.Canvas.Draw(0, 0, bmp);
  DrawMinimap();
end;

procedure UpdateTilemapTile(tileX, tileY, radius : Integer);
var x, y, screenX, screenY : Integer;
begin
  screenX:=tileX-offsetX;
  screenY:=tileY-offsetY;
  // Initialisieren einer neuen Bitmap
  // Diese wird benutzt um die Tiles auf die Form zu malen

  // Jedes Sichtbare Tile wird gesammtelt und zu einem Bild zusammengesetzt
  for x:=screenX-radius to screenX+radius do
  begin
    for y:=screenY-radius to screenY+radius do
    begin
      // schließt aus das außerhalb der Arrays abgefragt wird
      if (x>=0) and (x<=screenWidth-1) and (y>=0) and (y<=screenHeight-1)then
        begin
          Form1.Canvas.Draw(x*32, y*32, Tilemap.GetTileBitmap(x+offsetX, y+offsetY));
        end;
    end;
  end;

  // Die Tiles werden auf das Form gemalt
  UpdateMinimapTile(tileX, tileY);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin

end;

procedure MoveCamera(x, y: Integer);
begin

  // Ver#ndern der Kameraposition durch setzten der Offsets
  offsetX:=x;
  offsetY:=y;

  // Kamera darf nicht über sichtbaren Bereich hinaus
  // X
  if offsetX<0 then
     offsetX:=0;
  if offsetX>mapWidth-screenWidth-1 then
     offsetX:=mapWidth-screenWidth-1;

  // Y
  if offsetY<0 then
     offsetY:=0;
  if offsetY>mapHeight-screenHeight then
     offsetY:=mapHeight-screenHeight;

  DrawMap();
end;

procedure PlaceTerrainTile(x, y, id : Integer);
begin
  terrain[x][y]:=id;

  UpdateTilemapTile(x, y, 5);
end;

procedure TForm1.FormClick(Sender: TObject);
var tilePos, mousePos:TPoint;
begin
  mousePos:=Form1.ScreenToClient(TPoint.Create(Mouse.CursorPos.X, Mouse.CursorPos.Y));

  // Klick in Tilemap
  if (mousePos.X < (screenWidth*32)) and (mousePos.Y<(screenHeight*32)) then
     begin
       TilePos:=Tilemap.FormCoordsToTile(mousePos.X+(offsetX*32), mousePos.Y+(offsetY*32));

       // Build Tile
       if Form1.ToggleBox1.Checked then
         begin
           PlaceBuildingTile(tilePos.X, tilePos.Y, Form1.SpinEdit1.Value);
           UpdateTilemapTile(tilePos.x, tilepos.y, 4);
         end


       // Destroy Tile
       else if Form1.ToggleBox2.Checked then
         begin
           DestroyBuildingTile(tilepos.x, tilepos.Y);
           UpdateTilemapTile(tilePos.x, tilepos.y, 4);
         end

       // Click Tile
       else
         //DebugTile(TilePos.X, TilePos.Y);

       //DrawMap();
     end;

  // Klick in Minimap
  if (mousePos.X > ((screenWidth*32)+32)) and (mousePos.Y < mapHeight+32) then
      MoveCamera((mousePos.X-(screenWidth*32)-Round(screenWidth/2))-32, (mousePos.Y-Round(screenHeight/2))-32);

end;

procedure TForm1.Image1Click(Sender: TObject);
begin
  SpinEdit1.Value:=7;
end;

procedure TForm1.Image2Click(Sender: TObject);
begin
  SpinEdit1.Value:=9;
end;

procedure TForm1.Arrow2Click(Sender: TObject);
begin
  MoveCamera(offsetX, offsetY-1);
end;

procedure TForm1.Arrow3Click(Sender: TObject);
begin
  MoveCamera(offsetX, offsetY+1);
end;

procedure TForm1.Arrow4Click(Sender: TObject);
begin
  MoveCamera(offsetX+1, offsetY);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  // Start des Programms
  SetUpGui();
  GenerateMap();
  DrawMap();
  DrawMinimap();
end;

procedure TForm1.Arrow1Click(Sender: TObject);
begin
  MoveCamera(offsetX-1, offsetY);
end;
initialization
begin
  // Wird bei Programmstart ausgeführt
  GenerateMap();
end;
end.


