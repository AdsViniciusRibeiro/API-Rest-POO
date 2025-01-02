unit ServerMethods;

interface

uses
  System.SysUtils, System.Classes, Datasnap.DSServer, Datasnap.DSAuth, System.JSON,
  FireDAC.Comp.Client, uConexao, uConveterDataSet, DataSetConverter4D,
  DataSetConverter4D.Impl, System.StrUtils;

type
{$METHODINFO ON}
  TServerMethods = class(TComponent)
  private
    FConexao : TConexaoPG;
  public
    function EchoString(Value: string): string;
    function ReverseString(Value: string): string;

    function updatePessoa(_AJSONValue: TJSONValue): TJSONValue;
    function InsertPessoa(_AJSONValue : WideString) : TJSONValue;   //accept
    function acceptInsertPessoa(_AJSONValue : WideString): TJSONValue;
    function UpdateInsertPessoa(_AJSONValue : WideString): TJSONValue;
    function ListarPessoa : TJSONValue;
    function RetornaMaiorID : TJSONValue;
  end;
{$METHODINFO OFF}

implementation


function TServerMethods.EchoString(Value: string): string;
begin
  Result := Value;
end;

function TServerMethods.InsertPessoa(_AJSONValue : WideString): TJSONValue;
var
  JsonObj: TJSONObject;
  QryInsert: TFDQuery;
  ConexaoBanco : TConexaoPG;
begin
  ConexaoBanco := TConexaoPG.Create;
  QryInsert := ConexaoBanco.CriarQuery();
  try
    //if (_AJSONValue.Value <> '') or (_AJSONValue.Value <> 'null') then
    begin
      //JsonObj := _AJSONValue as TJSONObject;
      JsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes('{'+ _AJSONValue + '}'), 0) as TJSONObject;

      if JsonObj.Count > 1 then
        QryInsert.ExecSQL('insert into pessoa values ' +
                         '(:Codigo, :Natureza, :Documento, :Nome, :Sobrenome, :Data)',
                         [JsonObj.GetValue<Integer>(LowerCase('IDPessoa')),
                          JsonObj.GetValue<Integer>(LowerCase('Natureza')),
                          JsonObj.GetValue<string>(LowerCase('Documento')),
                          JsonObj.GetValue<string>(LowerCase('PrimeiroNome')),
                          JsonObj.GetValue<string>(LowerCase('SegundoNome')),
                          JsonObj.GetValue<string>(LowerCase('DataRegistro'))]);
    end;
    try
      Result := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes('{"IDPessoa":1,"Natureza":1,"Documento":"123","PrimeiroNome":"Vinicius","SegundoNome":"Ribeiro","DataRegistro":"2024-12-30","CEP":"36880246"}'), 0) as TJSONObject;
    finally
      QryInsert.Close;  //_AJSONValue.GetValue('aaa').Value.ToInteger()
    end;
  finally
    QryInsert.Free;
  end;
end;

function TServerMethods.acceptInsertPessoa(_AJSONValue : WideString): TJSONValue;
var
  JsonObj: TJSONObject;
  QryInsert: TFDQuery;
  ConexaoBanco : TConexaoPG;
begin
  ConexaoBanco := TConexaoPG.Create;
  QryInsert := ConexaoBanco.CriarQuery();
  try
    //if (_AJSONValue.Value <> '') or (_AJSONValue.Value <> 'null') then
    begin
      //JsonObj := _AJSONValue as TJSONObject;
      JsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(_AJSONValue), 0) as TJSONObject;

      if JsonObj.Count > 1 then
        QryInsert.ExecSQL('insert into pessoa values ' +
                         '(:Codigo, :Natureza, :Documento, :Nome, :Sobrenome, :Data)',
                         [JsonObj.GetValue<Integer>('IDPessoa'),
                          JsonObj.GetValue<Integer>('Natureza'),
                          JsonObj.GetValue<string>('Documento'),
                          JsonObj.GetValue<string>('PrimeiroNome'),
                          JsonObj.GetValue<string>('SegundoNome'),
                          StrToDate(JsonObj.GetValue<string>(('DataRegistro')))]);
    end;
    try
      Result := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes('{"IDPessoa":1,"Natureza":1,"Documento":"123","PrimeiroNome":"Vinicius","SegundoNome":"Ribeiro","DataRegistro":"2024-12-30","CEP":"36880246"}'), 0) as TJSONObject;
    finally
      QryInsert.Close;  //_AJSONValue.GetValue('aaa').Value.ToInteger()
    end;
  finally
    QryInsert.Free;
  end;
end;

function TServerMethods.UpdateInsertPessoa(_AJSONValue : WideString): TJSONValue;
var
  JsonObj: TJSONObject;
  QryInsert: TFDQuery;
  ConexaoBanco : TConexaoPG;
begin
  ConexaoBanco := TConexaoPG.Create;
  QryInsert := ConexaoBanco.CriarQuery();
  try
    //if (_AJSONValue.Value <> '') or (_AJSONValue.Value <> 'null') then
    begin
      //JsonObj := _AJSONValue as TJSONObject;
      JsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes('{'+ _AJSONValue + '}'), 0) as TJSONObject;

      if JsonObj.Count > 1 then
        QryInsert.ExecSQL('insert into pessoa values ' +
                         '(:Codigo, :Natureza, :Documento, :Nome, :Sobrenome, :Data)',
                         [JsonObj.GetValue<Integer>(LowerCase('IDPessoa')),
                          JsonObj.GetValue<Integer>(LowerCase('Natureza')),
                          JsonObj.GetValue<string>(LowerCase('Documento')),
                          JsonObj.GetValue<string>(LowerCase('PrimeiroNome')),
                          JsonObj.GetValue<string>(LowerCase('SegundoNome')),
                          JsonObj.GetValue<string>(LowerCase('DataRegistro'))]);
    end;
    try
      Result := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes('{"IDPessoa":1,"Natureza":1,"Documento":"123","PrimeiroNome":"Vinicius","SegundoNome":"Ribeiro","DataRegistro":"2024-12-30","CEP":"36880246"}'), 0) as TJSONObject;
    finally
      QryInsert.Close;  //_AJSONValue.GetValue('aaa').Value.ToInteger()
    end;
  finally
    QryInsert.Free;
  end;
end;

function TServerMethods.ListarPessoa : TJSONValue;
var
  QryPessoa: TFDQuery;
  ConexaoBanco : TConexaoPG;
begin
  ConexaoBanco := TConexaoPG.Create;
  QryPessoa := ConexaoBanco.CriarQuery();
  try
    QryPessoa.Open('Select P.*, E.dscep ' +
                   'from pessoa P ' +
                   'inner join endereco E on E.idpessoa = P.idpessoa');
    try          //TConverter.New.DataSet(Self).AsJSONArray;
      Result := TConverter.New.DataSet(QryPessoa).AsJSONArray;
    finally
      QryPessoa.Close;
    end;
  finally
    QryPessoa.Free;
  end;
end;

function TServerMethods.RetornaMaiorID : TJSONValue;
var
  QryPessoa: TFDQuery;
  ConexaoBanco : TConexaoPG;
begin
  ConexaoBanco := TConexaoPG.Create;
  QryPessoa := ConexaoBanco.CriarQuery();
  try
    QryPessoa.Open('Select MAX(idpessoa) + 1 MaiorID from pessoa');
    try
      Result := TConverter.New.DataSet(QryPessoa).AsJSONObject;
    finally
      QryPessoa.Close;
    end;
  finally
    QryPessoa.Free;
  end;
end;

function TServerMethods.ReverseString(Value: string): string;
begin
  Result := System.StrUtils.ReverseString(Value);
end;

function TServerMethods.updatePessoa(_AJSONValue: TJSONValue): TJSONValue;
begin
  Result := TJSONObject.Create;
end;

end.

