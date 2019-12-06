___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "modify JSON Array",
  "categories": ["ANALYTICS", "AFFILIATE_MARKETING", "ADVERTISING"],
  "description": "this custom variable can rename object key , change object value format.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "sourceArray",
    "displayName": "source JSON Array",
    "simpleValueType": true,
    "alwaysInSummary": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "help": "カスタムJavaScript変数などにより読み込んだキーの情報に変更を加えたいJSON配列を指定指定してください"
  },
  {
    "type": "SIMPLE_TABLE",
    "name": "modifyRules",
    "displayName": "modify rules",
    "simpleTableColumns": [
      {
        "defaultValue": "",
        "displayName": "target key name",
        "name": "sourceKeyName",
        "type": "TEXT",
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ],
        "valueHint": "key",
        "isUnique": true
      },
      {
        "defaultValue": "",
        "displayName": "new key name",
        "name": "newKeyName",
        "type": "TEXT",
        "isUnique": false,
        "valueHint": "key"
      },
      {
        "defaultValue": "default",
        "displayName": "new key format",
        "name": "newKeyFormat",
        "type": "SELECT",
        "selectItems": [
          {
            "value": "default",
            "displayValue": "default"
          },
          {
            "value": "string",
            "displayValue": "String - 文字列化"
          },
          {
            "value": "number",
            "displayValue": "Number - 数値化"
          },
          {
            "value": "boolean",
            "displayValue": "Boolean - 真偽値化"
          }
        ],
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ]
      }
    ],
    "help": "JSON配列内のオブジェクトのキーを変換するためのルールを定義します",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "alwaysInSummary": false
  },
  {
    "type": "SELECT",
    "name": "otherKeyRule",
    "displayName": "other keys rule",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "doNothing",
        "displayValue": "do nothing - そのまま出力"
      },
      {
        "value": "delete",
        "displayValue": "delete - 削除する"
      }
    ],
    "simpleValueType": true,
    "defaultValue": "doNothing",
    "help": "modify rulesの項目で指定しなかったキーの扱いを設定します。",
    "alwaysInSummary": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

// テンプレート コードをここに入力します。
const log = require('logToConsole');
log('data =', data);

// テンプレート コードをここに入力します。
const sourceArray = data.sourceArray;
const modifyRules = data.modifyRules;
const otherKeyRule = data.otherKeys;

log("source",sourceArray);

let newArray = [];


// 元データの配列を一つ取り出す
for(let i = 0; i < sourceArray.length; i++){
  // 新しい配列に挿入するオブジェクトの元データを作る
  let newObj = {};
  // オブジェクトの中のキーを一つずつ抜き出して調べる
  for(let key in sourceArray[i]){
    if(sourceArray[i].hasOwnProperty(key)){
      let newKey = key;
      let newValue = sourceArray[i][key];
      log(key , newValue);
      // 変換ルールテーブルに対応する列名があるか調べる
      let foundKeyFlag = false;
      for(let j = 0; j < modifyRules.length; j++){
        if(modifyRules[j].sourceKeyName === key){
          foundKeyFlag = true;
          // 新しい値のフォーマットが指定されていれば変換する
          if(modifyRules[j].newKeyFormat !== "default"){
            if(modifyRules[j].newKeyFormat !== "string"){
              newValue = newValue.toString();
            }else if(modifyRules[j].newKeyFormat !== "number"){
              newValue = newValue - 0;
            }else if(modifyRules[j].newKeyFormat !== "boolean"){
              newValue = !!newValue;
            }
            sourceArray[i][key] = newValue;
          }
          // 新しいキー名が指定されていたら変更する
          if(typeof modifyRules[j].newKeyName !== "undefined" && modifyRules[j].newKeyName.length > 0){
            newKey = modifyRules[j].newKeyName;
          }
          break;
        }
      }
      if(foundKeyFlag){
        newObj[newKey] = newValue;
      }else{
        if(otherKeyRule === "doNothing"){
          newObj[newKey] = newValue;
        }
      }      
    }
  }
  newArray.push(newObj);
}

log("result",newArray);

// 変数は値を返す必要があります。
return false;


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: Untitled test 1
  code: |-
    // Call runCode to run the template's code.
    let variableResult = runCode({
      sourceArray : [{id : "36", price : 2950, quantity : 2},{id : "37", price : 1960, quantity : 1,hoge:1}],
      modifyRules:[
        {sourceKeyName : "id", newKeyName : "code", newKeyFormat : "string"},
        {sourceKeyName : "price", newKeyName : undefined, newKeyFormat : "number"},
        {sourceKeyName : "quantity", newKeyName : undefined, newKeyFormat : "number"}
      ],
      otherKeyRule :"doNothing"
    });

    // Verify that the variable returns a result.
    assertThat(variableResult).isNotEqualTo(undefined);


___NOTES___

Created on 2019/12/6 21:04:26


