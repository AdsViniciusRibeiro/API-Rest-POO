unit uClasseAPI;

interface

uses
  REST.Types, REST.Client;

type
  TAPI = class
  private
    FRESTClient   : TRESTClient;
    FRESTRequest  : TRESTRequest;
    FRESTResponse : TRESTResponse;
    FJsonRetorno  : WideString;
    FCodigoRetonoJson : Integer;

    procedure SetCodigoRetonoJson(const Value: Integer);
    procedure SetJsonRetorno(const Value: WideString);

    public
      constructor Create;
      destructor Destroy;
      procedure ConfigurarRestClient(URl : string);
      procedure ConfigurarRestRequest(Metodo : TRESTRequestMethod);
      procedure ConfigurarRestResponse(sType : string);
      procedure ParametrosJson(ValorEnvio : WideString);
      procedure ExecutarAPI;

      property JsonRetorno : WideString read FJsonRetorno write SetJsonRetorno;
      property CodigoRetonoJson : Integer read FCodigoRetonoJson write SetCodigoRetonoJson;
  end;

implementation

{ TAPI }

procedure TAPI.ConfigurarRestClient(URl: string);
begin
  FRESTClient.Accept        := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  FRESTClient.AcceptCharset := 'utf-8, *;q=0.8';
  FRESTClient.BaseURL       := URl;
end;

procedure TAPI.ConfigurarRestRequest(Metodo : TRESTRequestMethod);
begin
  FRESTRequest.Accept        := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  FRESTRequest.AcceptCharset := 'utf-8, *;q=0.8';
  FRESTRequest.Client        := FRESTClient;
  FRESTRequest.Response      := FRESTResponse;
  FRESTRequest.Method        := Metodo;
end;

procedure TAPI.ConfigurarRestResponse(sType: string);
begin
  FRESTResponse.ContentType := sType;
end;

constructor TAPI.Create;
begin
  FRESTClient   := TRESTClient.Create(nil);
  FRESTRequest  := TRESTRequest.Create(nil);
  FRESTResponse := TRESTResponse.Create(nil);
end;

destructor TAPI.Destroy;
begin
  FRESTClient.Free;
  FRESTRequest.Free;
  FRESTResponse.Free;
end;

procedure TAPI.ExecutarAPI;
begin
  FRESTRequest.Execute;

  SetJsonRetorno(FRESTResponse.Content);
  SetCodigoRetonoJson(FRESTResponse.StatusCode);
end;

procedure TAPI.ParametrosJson(ValorEnvio: WideString);
begin
  case FRESTRequest.Method of
    rmPOST, rmPUT: begin
                     FRESTRequest.Params.Add;
                     FRESTRequest.Params[0].ContentType := 'application/json';
                     FRESTRequest.Params[0].Kind        := pkREQUESTBODY;
                     FRESTRequest.Params[0].Name        := 'Json';
                     FRESTRequest.Params[0].Value       := ValorEnvio;
                   end;
    rmGET: ;
    rmDELETE: FRESTRequest.Resource := ValorEnvio;
    rmPATCH: ;
  end;
end;

procedure TAPI.SetCodigoRetonoJson(const Value: Integer);
begin
  FCodigoRetonoJson := Value;
end;

procedure TAPI.SetJsonRetorno(const Value: WideString);
begin
  FJsonRetorno := Value;
end;

end.
