unit uControlerCEP;

interface

uses
  uCEP, IdHTTP, Winapi.WinInet, System.JSON, StrUtils, SysUtils;

type
  TControlerCEP = class

    public
      function BuscaCep(CEPPesquisa : String; var sMsg : String) : Boolean;
  end;

implementation

function TControlerCEP.BuscaCep(CEPPesquisa : String; var sMsg : String) : Boolean;
var
  HTTP       : TidHTTP;
  JSonString : String;
begin
  if InternetCheckConnection('https://viacep.com.br/', 1, 0) then
  begin
    HTTP := TIdHTTP.Create(nil);
    JSonString := HTTP.Get('http://viacep.com.br/ws/' + CEPPesquisa + '/json/');

    with TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JSonString), 0) as TJSONObject do
    try
      if Count > 1 then
      begin
        {Cep         := AnsiUpperCase(Get(0).JsonValue.Value);
        Logradouro  := AnsiUpperCase(Get(1).JsonValue.Value);
        Complemento := AnsiUpperCase(Get(2).JsonValue.Value);
        Bairro      := AnsiUpperCase(Get(3).JsonValue.Value);
        Localidade  := AnsiUpperCase(Get(4).JsonValue.Value);
        UF          := AnsiUpperCase(Get(5).JsonValue.Value);
        Unidade     := AnsiUpperCase(Get(6).JsonValue.Value);
        Ibge        := AnsiUpperCase(Get(7).JsonValue.Value);
        Gia         := AnsiUpperCase(Get(8).JsonValue.Value);}

        Result := True;
      end
      else
        sMsg := 'Cep não encontrado.'
    finally
      Free;
    end;
  end
  else
    raise Exception.Create('Falha ao conectar com ViaCep');
end;

end.
