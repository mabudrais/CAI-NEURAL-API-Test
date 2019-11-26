unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, Grids,
  neuralnetwork, neuralvolume, neuralfit, neuraldatasets, neuralopencl,
  neuralvolumev, FileUtil;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    ComboBox1: TComboBox;
    Image1: TImage;
    Label1: TLabel;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  NN: THistoricalNets;
  pOutPut, pInput: TNNetVolume;
  k: integer;

begin
  NN := THistoricalNets.Create();
  NN.LoadFromFile('SimpleImageClassifier.nn');
  pInput := TNNetVolume.Create(32, 32, 3, 1);
  pOutPut := TNNetVolume.Create(10, 1, 1, 1);
  LoadPictureIntoVolume(Image1.Picture, pInput);
  // pInput.RgbImgToNeuronalInput(csEncodeRGB);
  NN.Compute(pInput);
  NN.GetOutput(pOutPut);
  Label1.Caption := csTinyImageLabel[pOutPut.GetClass()];
  for k := 1 to 10 do
    StringGrid1.Cells[1, k] := FloatToStr(NN.Layers[NN.Layers.Count-2].Output.Raw[k - 1]);
  NN.Free;
  pInput.Free;
  pOutPut.Free;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  if FileExists(ComboBox1.Caption) then
    Image1.Picture.LoadFromFile(ComboBox1.Caption);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  k: integer;
begin
  for k := 0 to 9 do
    StringGrid1.Cells[0, k+1] := csTinyImageLabel[k];
  FindAllFiles(ComboBox1.Items, 'data');
  if ComboBox1.Items.Count > 0 then
  begin
    ComboBox1.Caption := ComboBox1.Items[0];
    if FileExists(ComboBox1.Caption) then
      Image1.Picture.LoadFromFile(ComboBox1.Caption);
  end;
end;

end.
