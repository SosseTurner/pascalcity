unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Arrow, ComCtrls, Menus, LazLogger, DateUtils,
  Tilemap;

type

  { TForm1 }

  TForm1 = class(TForm)
    Arrow1: TArrow;
    Arrow2: TArrow;
    Arrow3: TArrow;
    Arrow4: TArrow;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
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
    Image27: TImage;
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
    Image41: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Label15: TLabel;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    SaveDialog1: TSaveDialog;
    StaticText1: TStaticText;
    StaticText10: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    StaticText8: TStaticText;
    StaticText9: TStaticText;
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
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure Image10Click(Sender: TObject);
    procedure Image11Click(Sender: TObject);
    procedure Image12Click(Sender: TObject);
    procedure Image13Click(Sender: TObject);
    procedure Image14Click(Sender: TObject);
    procedure Image15Click(Sender: TObject);
    procedure Image16Click(Sender: TObject);
    procedure Image17Click(Sender: TObject);
    procedure Image18Click(Sender: TObject);
    procedure Image19Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image20Click(Sender: TObject);
    procedure Image21Click(Sender: TObject);
    procedure Image22Click(Sender: TObject);
    procedure Image23Click(Sender: TObject);
    procedure Image24Click(Sender: TObject);
    procedure Image25Click(Sender: TObject);
    procedure Image27Click(Sender: TObject);
    procedure Image29Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image30Click(Sender: TObject);
    procedure Image31Click(Sender: TObject);
    procedure Image32Click(Sender: TObject);
    procedure Image33Click(Sender: TObject);
    procedure Image34Click(Sender: TObject);
    procedure Image35Click(Sender: TObject);
    procedure Image36Click(Sender: TObject);
    procedure Image37Click(Sender: TObject);
    procedure Image38Click(Sender: TObject);
    procedure Image39Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image40Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure Image7Click(Sender: TObject);
    procedure Image8Click(Sender: TObject);
    procedure Image9Click(Sender: TObject);
    procedure ToggleBox1Change(Sender: TObject);
    procedure ToggleBox2Change(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  selectedBuildingTile: Integer;
  statusBarGfx: Array[0..6] of TBitmap;
  dateTime:TDateTime;
  date:Integer;

implementation

{$R *.lfm}

{ TForm1 }

procedure SetUpGui();
begin
  // Verschiebt alle Gui-Elemente an die richtige Stelle

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

  // Speichern
  Form1.Button2.Left:=1728;
  Form1.Button2.Top:=364;
  Form1.Button2.Height:=64;
  Form1.Button2.Width:=64;
  Form1.Button2.Visible:=true;

  // Laden
  Form1.Button3.Left:=1792;
  Form1.Button3.Top:=364;
  Form1.Button3.Height:=64;
  Form1.Button3.Width:=64;
  Form1.Button3.Visible:=true;

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

     // S??den
     Form1.Arrow3.Left:=1568+Round(mapWidth/2)+16;
     Form1.Arrow3.Top:=mapHeight+32;
     Form1.Arrow3.Height:=32;
     Form1.Arrow3.Width:=32;

  // BauMenu
  Form1.PageControl1.Left:=1568;
  Form1.PageControl1.Top:=428;
  Form1.PageControl1.Width:=352;
  Form1.PageControl1.Height:=256;

    //Stra??en
      // Feldweg
      Form1.Image3.Width:=32;
      Form1.Image3.Height:=32;
      Form1.Image3.Left:=0;
      Form1.Image3.Top:=0;
      Form1.Image3.Picture.LoadFromFile('gfx/gui/build-menu/6.bmp');

      // Landstra??e 2-Spuren
      Form1.Image1.Width:=32;
      Form1.Image1.Height:=32;
      Form1.Image1.Left:=32;
      Form1.Image1.Top:=0;
      Form1.Image1.Picture.LoadFromFile('gfx/gui/build-menu/7.bmp');

      // Allee
      Form1.Image4.Width:=32;
      Form1.Image4.Height:=32;
      Form1.Image4.Left:=64;
      Form1.Image4.Top:=0;
      Form1.Image4.Picture.LoadFromFile('gfx/gui/build-menu/8.bmp');

      // Landstra??e 4-Spuren
      Form1.Image5.Width:=32;
      Form1.Image5.Height:=32;
      Form1.Image5.Left:=96;
      Form1.Image5.Top:=0;
      Form1.Image5.Picture.LoadFromFile('gfx/gui/build-menu/9.bmp');

    // Strom
      // Solar klein
      Form1.Image7.Width:=32;
      Form1.Image7.Height:=32;
      Form1.Image7.Left:=0;
      Form1.Image7.Top:=0;
      Form1.Image7.Picture.LoadFromFile('gfx/gui/build-menu/11.bmp');

      // Solar Gro??
      Form1.Image2.Width:=64;
      Form1.Image2.Height:=64;
      Form1.Image2.Left:=32;
      Form1.Image2.Top:=0;
      Form1.Image2.Picture.LoadFromFile('gfx/gui/build-menu/12.bmp');

      // Wasserkraftwerk
      Form1.Image8.Width:=64;
      Form1.Image8.Height:=64;
      Form1.Image8.Left:=96;
      Form1.Image8.Top:=0;
      Form1.Image8.Picture.LoadFromFile('gfx/gui/build-menu/13.bmp');

      // Kohlekraftwerk
      Form1.Image9.Width:=64;
      Form1.Image9.Height:=64;
      Form1.Image9.Left:=160;
      Form1.Image9.Top:=0;
      Form1.Image9.Picture.LoadFromFile('gfx/gui/build-menu/14.bmp');

      // Atomkraftwerk
      Form1.Image10.Width:=96;
      Form1.Image10.Height:=96;
      Form1.Image10.Left:=0;
      Form1.Image10.Top:=64;
      Form1.Image10.Picture.LoadFromFile('gfx/gui/build-menu/15.bmp');

    // Feuerwehr
      // Feuerwache klein
      Form1.Image11.Width:=32;
      Form1.Image11.Height:=32;
      Form1.Image11.Left:=0;
      Form1.Image11.Top:=0;
      Form1.Image11.Picture.LoadFromFile('gfx/gui/build-menu/20.bmp');

      // Feuerwache gro??
      Form1.Image12.Width:=64;
      Form1.Image12.Height:=64;
      Form1.Image12.Left:=32;
      Form1.Image12.Top:=0;
      Form1.Image12.Picture.LoadFromFile('gfx/gui/build-menu/21.bmp');

      // L??schhubschrauberlandeplatz
      Form1.Image13.Width:=96;
      Form1.Image13.Height:=96;
      Form1.Image13.Left:=0;
      Form1.Image13.Top:=64;
      Form1.Image13.Picture.LoadFromFile('gfx/gui/build-menu/22.bmp');

      // Feuerwehrzentrale
      Form1.Image14.Width:=128;
      Form1.Image14.Height:=128;
      Form1.Image14.Left:=96;
      Form1.Image14.Top:=0;
      Form1.Image14.Picture.LoadFromFile('gfx/gui/build-menu/23.bmp');

    // Polizei
      // Polizeiwache klein
      Form1.Image15.Width:=32;
      Form1.Image15.Height:=32;
      Form1.Image15.Left:=0;
      Form1.Image15.Top:=0;
      Form1.Image15.Picture.LoadFromFile('gfx/gui/build-menu/28.bmp');

      // Polizeiwache gro??
      Form1.Image16.Width:=64;
      Form1.Image16.Height:=64;
      Form1.Image16.Left:=32;
      Form1.Image16.Top:=0;
      Form1.Image16.Picture.LoadFromFile('gfx/gui/build-menu/29.bmp');

      // Polizeizentrale
      Form1.Image18.Width:=96;
      Form1.Image18.Height:=96;
      Form1.Image18.Left:=0;
      Form1.Image18.Top:=64;
      Form1.Image18.Picture.LoadFromFile('gfx/gui/build-menu/30.bmp');

      // Gef??ngnis
      Form1.Image17.Width:=128;
      Form1.Image17.Height:=128;
      Form1.Image17.Left:=96;
      Form1.Image17.Top:=0;
      Form1.Image17.Picture.LoadFromFile('gfx/gui/build-menu/31.bmp');

    // Gesundheit
        // Arztpraxis klein
      Form1.Image19.Width:=32;
      Form1.Image19.Height:=32;
      Form1.Image19.Left:=0;
      Form1.Image19.Top:=0;
      Form1.Image19.Picture.LoadFromFile('gfx/gui/build-menu/32.bmp');

      // Arztpraxis gro??
      Form1.Image20.Width:=64;
      Form1.Image20.Height:=64;
      Form1.Image20.Left:=32;
      Form1.Image20.Top:=0;
      Form1.Image20.Picture.LoadFromFile('gfx/gui/build-menu/33.bmp');

      // Krankenhaus
      Form1.Image22.Width:=96;
      Form1.Image22.Height:=96;
      Form1.Image22.Left:=0;
      Form1.Image22.Top:=64;
      Form1.Image22.Picture.LoadFromFile('gfx/gui/build-menu/34.bmp');

      // Medizinisches Zentrum
      Form1.Image21.Width:=128;
      Form1.Image21.Height:=128;
      Form1.Image21.Left:=96;
      Form1.Image21.Top:=0;
      Form1.Image21.Picture.LoadFromFile('gfx/gui/build-menu/35.bmp');

    // Wasser
      // Wasserturm klein
      Form1.Image24.Width:=32;
      Form1.Image24.Height:=32;
      Form1.Image24.Left:=0;
      Form1.Image24.Top:=0;
      Form1.Image24.Picture.LoadFromFile('gfx/gui/build-menu/16.bmp');

      // Wasserturm gro??
      Form1.Image23.Width:=64;
      Form1.Image23.Height:=64;
      Form1.Image23.Left:=32;
      Form1.Image23.Top:=0;
      Form1.Image23.Picture.LoadFromFile('gfx/gui/build-menu/17.bmp');

      // Wasserpumpe horizontal
      Form1.Image27.Width:=64;
      Form1.Image27.Height:=32;
      Form1.Image27.Left:=96;
      Form1.Image27.Top:=0;
      Form1.Image27.Picture.LoadFromFile('gfx/gui/build-menu/18.bmp');

      // Staudamm horizontal
      Form1.Image25.Width:=128;
      Form1.Image25.Height:=32;
      Form1.Image25.Left:=64;
      Form1.Image25.Top:=64;
      Form1.Image25.Picture.LoadFromFile('gfx/gui/build-menu/19.bmp');

    // Bildung
      // Kindergarten
      Form1.Image29.Width:=32;
      Form1.Image29.Height:=32;
      Form1.Image29.Left:=0;
      Form1.Image29.Top:=0;
      Form1.Image29.Picture.LoadFromFile('gfx/gui/build-menu/24.bmp');

      // Schule
      Form1.Image30.Width:=64;
      Form1.Image30.Height:=64;
      Form1.Image30.Left:=32;
      Form1.Image30.Top:=0;
      Form1.Image30.Picture.LoadFromFile('gfx/gui/build-menu/25.bmp');

      // Oberschule
      Form1.Image32.Width:=96;
      Form1.Image32.Height:=96;
      Form1.Image32.Left:=0;
      Form1.Image32.Top:=64;
      Form1.Image32.Picture.LoadFromFile('gfx/gui/build-menu/26.bmp');

      // Universit??t
      Form1.Image31.Width:=128;
      Form1.Image31.Height:=128;
      Form1.Image31.Left:=96;
      Form1.Image31.Top:=0;
      Form1.Image31.Picture.LoadFromFile('gfx/gui/build-menu/27.bmp');

    // Freizeit
      // Park
      Form1.Image33.Width:=32;
      Form1.Image33.Height:=32;
      Form1.Image33.Left:=0;
      Form1.Image33.Top:=0;
      Form1.Image33.Picture.LoadFromFile('gfx/gui/build-menu/36.bmp');

      // Theater
      Form1.Image34.Width:=32;
      Form1.Image34.Height:=32;
      Form1.Image34.Left:=32;
      Form1.Image34.Top:=0;
      Form1.Image34.Picture.LoadFromFile('gfx/gui/build-menu/37.bmp');

      // Kino
      Form1.Image35.Width:=64;
      Form1.Image35.Height:=64;
      Form1.Image35.Left:=64;
      Form1.Image35.Top:=0;
      Form1.Image35.Picture.LoadFromFile('gfx/gui/build-menu/38.bmp');

      // Stadion
      Form1.Image36.Width:=128;
      Form1.Image36.Height:=96;
      Form1.Image36.Left:=128;
      Form1.Image36.Top:=0;
      Form1.Image36.Picture.LoadFromFile('gfx/gui/build-menu/39.bmp');

    // Dekoration
      // Pinoraurier Statue
      Form1.Image37.Width:=32;
      Form1.Image37.Height:=32;
      Form1.Image37.Left:=0;
      Form1.Image37.Top:=0;
      Form1.Image37.Picture.LoadFromFile('gfx/gui/build-menu/40.bmp');

    // Zonen
      // Wohngebiet
      Form1.Image38.Width:=32;
      Form1.Image38.Height:=32;
      Form1.Image38.Left:=0;
      Form1.Image38.Top:=0;

      // Gewebegebiet
      Form1.Image39.Width:=32;
      Form1.Image39.Height:=32;
      Form1.Image39.Left:=32;
      Form1.Image39.Top:=0;

      // Industriegebiet
      Form1.Image40.Width:=32;
      Form1.Image40.Height:=32;
      Form1.Image40.Left:=64;
      Form1.Image40.Top:=0;

    // Einwohner
    Form1.StaticText2.Caption:='Einwohner:0';
    Form1.StaticText2.Top:=977;
    Form1.StaticText2.Left:=400;

    // Water
    Form1.StaticText3.Caption:='Water:0';
    Form1.StaticText3.Top:=977;
    Form1.StaticText3.Left:=850;

    // Energie
    Form1.StaticText4.Caption:='Energy:0';
    Form1.StaticText4.Top:=977;
    Form1.StaticText4.Left:=600;

    // Steuereinnahmen (Test)
    Form1.StaticText5.Caption:='Einnahmen ';
    Form1.StaticText5.Top:=977;
    Form1.StaticText5.Left:=206;

    // Kontostand (Test)
    Form1.StaticText1.Caption:='Kontostand ';
    Form1.StaticText1.Top:=977;
    Form1.StaticText1.Left:=50;

    // Datum
    Form1.StaticText6.Caption:='Weeks:0';
    Form1.StaticText6.Top:=977;
    Form1.StaticText6.Left:=1200;

    // Statusbar
    statusBarGfx[0]:=TBitmap.Create;
    statusBarGfx[0].LoadFromFile('gfx/gui/status-bar/income.bmp');
    Form1.Canvas.Draw(0, 960, statusBarGfx[0]);

    statusBarGfx[1]:=TBitmap.Create;
    statusBarGfx[1].LoadFromFile('gfx/gui/status-bar/residents.bmp');
    Form1.Canvas.Draw(315, 960, statusBarGfx[1]);

    statusBarGfx[2]:=TBitmap.Create;
    statusBarGfx[2].LoadFromFile('gfx/gui/status-bar/energyCapacity.bmp');
    Form1.Canvas.Draw(551, 960, statusBarGfx[2]);

    statusBarGfx[3]:=TBitmap.Create;
    statusBarGfx[3].LoadFromFile('gfx/gui/status-bar/waterCapacity.bmp');
    Form1.Canvas.Draw(770, 960, statusBarGfx[3]);

    statusBarGfx[4]:=TBitmap.Create;
    statusBarGfx[4].LoadFromFile('gfx/gui/status-bar/demand.bmp');
    Form1.Canvas.Draw(989, 960, statusBarGfx[4]);

    statusBarGfx[5]:=TBitmap.Create;
    statusBarGfx[5].LoadFromFile('gfx/gui/status-bar/date.bmp');
    Form1.Canvas.Draw(1163, 960, statusBarGfx[5]);

    statusBarGfx[6]:=TBitmap.Create;
    Form1.Image6.Left:=1399;
    Form1.Image6.Top:=960;
    Form1.Image6.Height:=57;
    Form1.Image6.Width:=169;
    Form1.Image6.Picture.LoadFromFile('gfx/gui/status-bar/nextWeek.bmp');

    // Inspektor

       //Preview
       Form1.Image41.Left:=1600;
       Form1.Image41.Top:=715;
       Form1.Image41.Height:=128;
       Form1.Image41.Width:=128;

       // Bewohner
       Form1.StaticText7.Left:=1740;
       Form1.StaticText7.Top:=715;
       Form1.StaticText7.Caption:='Bowohner:';

       // Level
       Form1.StaticText8.Left:=1740;
       Form1.StaticText8.Top:=747;
       Form1.StaticText8.Caption:='Geb??udelevel:';

       // Zufriedenheit
       Form1.StaticText9.Left:=1740;
       Form1.StaticText9.Top:=779;
       Form1.StaticText9.Caption:='Zufriedenheit:';
       // Einkommen
       Form1.StaticText10.Left:=1740;
       Form1.StaticText10.Top:=812;
       Form1.StaticText10.Caption:='Steuern:';
end;

procedure UpdateGui();
begin
  // Aktuallisert alle Gui-Elemente um ver??nderte Werte anzuzeigen

  // Statusbar
  Form1.Canvas.Draw(0, 960, statusBarGfx[0]);
  Form1.Canvas.Draw(315, 960, statusBarGfx[1]);
  Form1.Canvas.Draw(551, 960, statusBarGfx[2]);
  Form1.Canvas.Draw(770, 960, statusBarGfx[3]);
  Form1.Canvas.Draw(989, 960, statusBarGfx[4]);
  Form1.Canvas.Draw(1163, 960, statusBarGfx[5]);

  // Nachfrage
     //Clear
     Form1.Canvas.Brush.Color:=RGBToColor(192, 203, 220);
     Form1.Canvas.Pen.Color:=RGBToColor(192, 203, 220);
     Form1.Canvas.Rectangle(1054, 969, 1054+100, 969+39);
     //Wohnungen
     Form1.Canvas.Brush.Color:=RGBToColor(62, 137, 72);
     Form1.Canvas.Pen.Color:=RGBToColor(62, 137, 72);
     Form1.Canvas.Rectangle(1054, 969, 1054+Round(demandHouses*100), 969+13);
     //Gewerbe
     Form1.Canvas.Brush.Color:=RGBToColor(0, 153, 219);
     Form1.Canvas.Pen.Color:=RGBToColor(0, 153, 219);
     Form1.Canvas.Rectangle(1054, 981, 1054+Round(demandBusiness*100), 981+13);
     //Industriek
     Form1.Canvas.Brush.Color:=RGBToColor(254, 174, 52);
     Form1.Canvas.Pen.Color:=RGBToColor(254, 174, 52);
     Form1.Canvas.Rectangle(1054, 995, 1054+Round(demandIndustrie*100), 995+13);

  Form1.StaticText2.Caption:=IntToStr(residents);
  Form1.StaticText2.BringToFront;
  if (residents<>0) then
    begin
      Form1.StaticText3.Caption:=IntToStr(Round(waterCapacity*100/(residents+workplaces)));
      Form1.StaticText3.BringToFront;
      Form1.StaticText4.Caption:=IntToStr(Round(energyCapacity*100/(residents+workplaces)));
      Form1.StaticText4.BringToFront;
    end;
  Form1.StaticText5.Caption:=IntToStr(TotalIncome)+'???';
  Form1.StaticText6.Caption:=FormatDateTime('dd"/"mm"/"yyyy', dateTime+7*date);
  Form1.StaticText1.Caption:=IntToStr(BankAccount)+'???';
end;

procedure UpdateInspector(x, y:Integer);
begin
  // Aktuallisiert den Inspektor welcher die Werte f??r das angeklichte Geb??ude zeigt
  if (buildings[x][y].id<>0) then
    begin
      if (buildings[x][y].id=3)then
        Form1.Image41.Picture.Bitmap:=GetFlatBitmap(buildings[x][y].id, buildings[x][y].subId, buildings[x][y].level);
      if (buildings[x][y].id=4) or (buildings[x][y].id=5) then
        Form1.Image41.Picture.Bitmap:=GetBusinessBitmap(buildings[x][y].id, buildings[x][y].subId, buildings[x][y].level);
      if (buildings[x][y].id>5) and (buildings[x][y].id<41) then
        Form1.Image41.Picture.Bitmap.LoadFromFile('gfx/gui/build-menu/'+IntToStr(buildings[x][y].id)+'.bmp');
      Form1.StaticText7.Caption:='Einwohner: '+IntToStr(buildings[x][y].residents);
      Form1.StaticText8.Caption:='Geb??ude Level:'+IntToStr(buildings[x][y].level);
      Form1.StaticText9.Caption:='Zufriedenheit: '+IntToStr(buildings[x][y].happiness);
      Form1.StaticText10.Caption:='Steuern: '+IntToStr(buildings[x][y].localincome);
    end;
end;

procedure DrawMinimap();
var x, y : Integer;
    bmp:TBitmap;
begin
  // Die Minimap wird Pixel f??r Pixel neu, anhand der Geb??udefarbe ertstellt

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
  bmp.Destroy;

  // Der Sichtbare bereich wird durch umrandung kenntlich gemacht
  Form1.Canvas.Pen.Color:=clBlack;
  Form1.Canvas.Line((offsetX+32*screenWidth)+32, offsetY+32, (32+offsetX+screenWidth)+32*screenWidth, offsetY+32);
  Form1.Canvas.Line((offsetX+32*screenWidth)+32, offsetY+32, (offsetX+32*screenWidth)+32, offsetY+screenHeight+32);
  Form1.Canvas.Line((offsetX+32*screenWidth)+screenWidth+32, offsetY+32, (32+offsetX+screenWidth)+32*screenWidth, offsetY+screenHeight+32);
  Form1.Canvas.Line((offsetX+32*screenWidth)+32, offsetY+screenHeight+32, (32+offsetX+screenWidth)+32*screenWidth, offsetY+screenHeight+32);
end;

procedure UpdateMinimapTile(tileX, tileY : Integer);
var x, y : Integer;
  bmp: TBitmap;
begin
  // Die Minimap wird Pixel f??r Pixel neu, anhand der Geb??udefarbe ertstellt

  bmp:=TBitmap.Create;
  bmp.Height:=mapHeight;
  bmp.Width:=mapWidth;
  for x:=tileX-1 to tileX+1 do
  begin
    for y:=tileY-1 to tileY+1 do
    begin

      // Falls nach einer Koordinate au??erhalb des Arrays gefragt wird
      if (x>=0) and (x<=screenWidth-1) and (y>=0) and (y<=screenHeight-1)then
      begin
        if (buildings[x][y].id<3) then
          Form1.Canvas.Pixels[32*screenWidth+x+32, y+32]:=GetMinimapColor(terrain[x][y])
        else
          Form1.Canvas.Pixels[32*screenWidth+x+32, y+32]:=GetMinimapColor(buildings[x][y].id)
      end;
    end;
  end;
  bmp.Destroy;
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
  bmp.Destroy;
  DrawMinimap();
  UpdateGui();
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
      // schlie??t aus das au??erhalb der Arrays abgefragt wird
      if (x>=0) and (x<=screenWidth-1) and (y>=0) and (y<=screenHeight-1)then
        begin
          Form1.Canvas.Draw(x*32, y*32, Tilemap.GetTileBitmap(x+offsetX, y+offsetY));
        end;
    end;
  end;

  // Die Tiles werden auf das Form gemalt
  UpdateMinimapTile(tileX, tileY);
end;

procedure LoadGame();
var saveFileString:TStringList;
    line:String;
    splitLine:Array of String;
    x, y:Integer;
begin
  // Aus der ausgew??hlten Datei wird Zeile f??r Zeile die Zeile durchgegangen und auf die Anfangszeichen ??berpr??ft
  // der Character:';' fungiert als Trenzeichen f??r die Werte.
  
  // Falls im Fenster eine Datei ausgew??hlt wird, wird true wiedergegeben

  if Form1.OpenDialog1.Execute then
    begin
      saveFileString:=TStringList.Create;
      saveFileString.LoadFromFile(Form1.OpenDialog1.FileName);
      for line in saveFileString do
      begin
           splitLine:=line.Split(';');
      case splitline[0] of
        // steht f??r geb??ude
        // die in der Zeile stehenden Werte werden im Array buildings gespeichert
        'b':
          begin
            x:=StrToInt(splitLine[1]);
            y:=StrToInt(splitLine[2]);
            buildings[x][y].id:=StrToInt(splitLine[3]);
            buildings[x][y].subId:=StrToInt(splitLine[4]);
            buildings[x][y].residents:=StrToInt(splitLine[5]);
            buildings[x][y].maxResidents:=StrToInt(splitLine[6]);
            buildings[x][y].level:=StrToInt(splitLine[7]);
            buildings[x][y].happiness:=StrToInt(splitLine[8]);
            buildings[x][y].localincome:=StrToInt(splitLine[9]);
            buildings[x][y].buildprice:=StrToInt(splitLine[10]);
            buildings[x][y].isParentTile:=StrToBool(splitLine[11]);
          end;
        // steht f??r terrain
        // die in der Zeile stehenden Werte werden im Array terrain gespeichert  
        't':
          begin
            x:=StrToInt(splitLine[1]);
            y:=StrToInt(splitLine[2]);
            terrain[x][y]:=StrToInt(splitLine[3]);
          end;
          
        // steht f??r money/Bank Guthaben
        'm':
          bankAccount:=StrToInt(splitLine[1]);
        // steht f??r weeks past/woche vergangen
        'wp':
          date:=StrToInt(splitLine[1]);
        // steht f??r date started/ Startdatum      
        'ds':
          dateTime:=StrToUInt64(splitLine[1]);
      end;
    end;
  end;
  
  // Aktuallisert Alle Gui anzeigen und malt die Karte
  UpdateEnergyProduction();
  UpdateWaterProduction();
  UpdateAllResidents();
  UpdateAllWorkplaces();
  UpdateNumberOfBusinessZones();
  UpdateNumberOfIndustrialZones();
  UpdateDemant();
  UpdateGui();
  DrawMap();
end;

procedure SaveGame();
var saveString:TStringList;
    x, y:Integer;
begin
  // essentielle Werte wie BankGuthaben, Datum, date(anzahl der vergangenen Wochen), und die Arrays buildings und terrain werden gespeichert
  // Dazu wird eine StringList erstellt
  // Eine Zeile steht f??r einen Wert bspw: integer, Building(record)
  // durch ein Trennzeichen k??nnen zusammenh??ngende Werte in einen Zeile geschrieben werden und anschliesend wieder unterschieden werden
  if Form1.SaveDialog1.Execute then
    begin
    
      // Speichern der notwendigen Variablen
      saveString:=TStringList.Create;
      saveString.Add('m;'+IntToSTr(bankAccount));
      saveString.Add('wp;'+IntToSTr(date));
      saveString.Add('ds;'+ IntToStr(trunc(dateTime)));

      // Speichern jedes Geb??udes des Arrays buildings
      for x:=0 to mapWidth-1 do
      begin
        for y:=0 to mapHeight-1 do
        begin
          saveString.Add('b;'+IntToStr(x)+';'+IntToStr(y)+';'+IntToStr(buildings[x][y].id)+';'+IntToStr(buildings[x][y].subId)+';'+IntToStr(buildings[x][y].residents)+';'+IntToStr(buildings[x][y].maxResidents)+';'+IntToStr(buildings[x][y].level)+';'+IntToStr(buildings[x][y].happiness)+';'+IntToStr(buildings[x][y].localincome)+';'+IntToStr(buildings[x][y].buildprice)+';'+BoolToSTr(buildings[x][y].isParentTile));
        end;
      end;

      // Speichern jedes Integers des Arrays terrain
      for x:=0 to mapWidth-1 do
      begin
        for y:=0 to mapHeight-1 do
        begin
          saveString.Add('t;'+IntToStr(x)+';'+IntToStr(y)+';'+IntToStr(terrain[x][y]));
        end;
      end;

      saveString.SaveToFile(Form1.SaveDialog1.FileName);
      saveString.Free;
    end;

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  // L??dt die Spielwert aus einer Datei 
  LoadGame();
end;

procedure MoveCamera(x, y: Integer);
begin

  // Ver#ndern der Kameraposition durch setzten der Offsets
  offsetX:=x;
  offsetY:=y;

  // Kamera darf nicht ??ber sichtbaren Bereich hinaus
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
  // Registriert die Klicks auf die Form 
  // Anhand von der Possition werden weitere Mothoden aufger??fen
  mousePos:=Form1.ScreenToClient(TPoint.Create(Mouse.CursorPos.X, Mouse.CursorPos.Y));

  // Klick in Tilemap
  if (mousePos.X < (screenWidth*32)) and (mousePos.Y<(screenHeight*32)) then
     begin
       TilePos:=Tilemap.FormCoordsToTile(mousePos.X+(offsetX*32), mousePos.Y+(offsetY*32));

       // Build Tile
       if Form1.ToggleBox1.Checked then
         begin
           PlaceBuildingTile(tilePos.X, tilePos.Y, selectedBuildingTile);
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
         begin
           UpdateInspector(tilePos.x, tilepos.y);
           StaticText1.Caption:=IntToStr(BankAccount)+'???';
         end;

     end;

  // Klick in Minimap
  if (mousePos.X > ((screenWidth*32)+32)) and (mousePos.Y < mapHeight+32) then
      MoveCamera((mousePos.X-(screenWidth*32)-Round(screenWidth/2))-32, (mousePos.Y-Round(screenHeight/2))-32);

end;


// Fast Alle folgenden proceduren sind teil des Baumenus
// Diese dienen dazu um die Id des angeklichten Geb??udes zu speichern
procedure TForm1.Image10Click(Sender: TObject);
begin
  selectedBuildingTile:=15;
end;

procedure TForm1.Image11Click(Sender: TObject);
begin
  selectedBuildingTile:=20;
end;

procedure TForm1.Image12Click(Sender: TObject);
begin
  selectedBuildingTile:=21;
end;

procedure TForm1.Image13Click(Sender: TObject);
begin
  selectedBuildingTile:=22;
end;

procedure TForm1.Image14Click(Sender: TObject);
begin
  selectedBuildingTile:=23;
end;

procedure TForm1.Image15Click(Sender: TObject);
begin
  selectedBuildingTile:=28;
end;

procedure TForm1.Image16Click(Sender: TObject);
begin
  selectedBuildingTile:=29;
end;

procedure TForm1.Image17Click(Sender: TObject);
begin
  selectedBuildingTile:=31;
end;

procedure TForm1.Image18Click(Sender: TObject);
begin
  selectedBuildingTile:=30;
end;

procedure TForm1.Image19Click(Sender: TObject);
begin
  selectedBuildingTile:=32;
end;

procedure TForm1.Image1Click(Sender: TObject);
begin
  selectedBuildingTile:=7;
end;

procedure TForm1.Image20Click(Sender: TObject);
begin
  selectedBuildingTile:=33;
end;

procedure TForm1.Image21Click(Sender: TObject);
begin
  selectedBuildingTile:=35;
end;

procedure TForm1.Image22Click(Sender: TObject);
begin
  selectedBuildingTile:=34;
end;

procedure TForm1.Image23Click(Sender: TObject);
begin
  selectedBuildingTile:=17;
end;

procedure TForm1.Image24Click(Sender: TObject);
begin
  selectedBuildingTile:=16;
end;

procedure TForm1.Image25Click(Sender: TObject);
begin
  selectedBuildingTile:=19;
end;

procedure TForm1.Image27Click(Sender: TObject);
begin
  selectedBuildingTile:=18;
end;

procedure TForm1.Image29Click(Sender: TObject);
begin
  selectedBuildingTile:=24;
end;

procedure TForm1.Image2Click(Sender: TObject);
begin
  selectedBuildingTile:=12;
end;

procedure TForm1.Image30Click(Sender: TObject);
begin
  selectedBuildingTile:=25;
end;

procedure TForm1.Image31Click(Sender: TObject);
begin
  selectedBuildingTile:=27;
end;

procedure TForm1.Image32Click(Sender: TObject);
begin
  selectedBuildingTile:=26;
end;

procedure TForm1.Image33Click(Sender: TObject);
begin
  selectedBuildingTile:=36;
end;

procedure TForm1.Image34Click(Sender: TObject);
begin
  selectedBuildingTile:=37;
end;

procedure TForm1.Image35Click(Sender: TObject);
begin
  selectedBuildingTile:=38;
end;

procedure TForm1.Image36Click(Sender: TObject);
begin
  selectedBuildingTile:=39;
end;

procedure TForm1.Image37Click(Sender: TObject);
begin
  selectedBuildingTile:=40;
end;

procedure TForm1.Image38Click(Sender: TObject);
begin
  selectedBuildingTile:=3;
end;

procedure TForm1.Image39Click(Sender: TObject);
begin
  selectedBuildingTile:=4;
end;

procedure TForm1.Image3Click(Sender: TObject);
begin
   selectedBuildingTile:=6;
end;

procedure TForm1.Image40Click(Sender: TObject);
begin
  selectedBuildingTile:=5;
end;

procedure TForm1.Image4Click(Sender: TObject);
begin
  selectedBuildingTile:=8;
end;

procedure TForm1.Image5Click(Sender: TObject);
begin
  selectedBuildingTile:=9;
end;


// Image welches als Button fungiert
// Ruft alle Mothoden zur Berechnung der neuen Woche auf
procedure TForm1.Image6Click(Sender: TObject);
begin
  inc(date);
  UpdateEnergyProduction();
  UpdateWaterProduction();
  CalculateHappiness();
  CalculateTaxIncome();
  UpdateBankAccount();
  UpdateZones();
  CalculateHappiness();
  UpdateGui();
  DrawMap();
end;

procedure TForm1.Image7Click(Sender: TObject);
begin
  selectedBuildingTile:=11;
end;

procedure TForm1.Image8Click(Sender: TObject);
begin
  selectedBuildingTile:=13;
end;

procedure TForm1.Image9Click(Sender: TObject);
begin
  selectedBuildingTile:=14;
end;

procedure TForm1.ToggleBox1Change(Sender: TObject);
begin
  if (ToggleBox1.Checked) then
    ToggleBox2.Checked:=false;
end;

procedure TForm1.ToggleBox2Change(Sender: TObject);
begin
  if (ToggleBox2.Checked) then
    ToggleBox1.Checked:=false;
end;

// Pfeile zum verschieden der Kamera
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

// Speichert die antuelle Welt in einer Datei (*.pasc)
procedure TForm1.Button2Click(Sender: TObject);
begin
  SaveGame();
  ShowMessage('Speichern erfolgreich!');
end;

// Pfeile zum verschieden der Kamera
procedure TForm1.Arrow1Click(Sender: TObject);
begin
  MoveCamera(offsetX-1, offsetY);
end;
initialization
begin
  dateTime:= now;
  // Wird bei Programmstart ausgef??hrt
end;
end.


