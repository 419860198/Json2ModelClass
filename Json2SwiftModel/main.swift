//
//  main.swift
//  Json2ModelClass
//
//  Created by zhangxiaobo on 2019/3/5.
//  Copyright © 2019年 BG. All rights reserved.
//

import Foundation
var clasSuffix = "Model"

class Model {
  var dict: [String: Any] = [:]
  init(_ dict: [String: Any]) {
    self.dict = dict
  }
}

func josnToModel(json: String) {
  let jsonData:Data = json.data(using: .utf8)!
  let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
  if let d = dict as? [String: Any] {
    pringtOutMap(Model(d), className: "SomeClass")
    print("\n\n\n json转model成功")
    exit(1)
  }
  print("输入的json格式有误")
  exit(0)
}

func pringtOutMap(_ model: Model, className: String) {
  print("\n")
  print("class \(className): YSYBaseModel {\n")
  let dict = model.dict
  var keys: [String] = []
  for key in dict.keys {
    keys.append(key)
  }
  keys.sort()

  var newClass: [String: Model] = [:]

  for key in keys {
    let value = dict[key]
    if let _ = value as? String {
      print("  var \(key): String = \"\"")
    }else if let va = value as? [String: Any] {
      let clase = key + clasSuffix
      print("  var \(key): \(clase)?")
      newClass[clase] = Model(va)
      //      defer {pringtOutMap(Model(va), className: clase)}
    }else if let va = value as? [Any] {
      if va.count > 0{
        if let fist = va[0] as? [String: Any] {
          let clase = key + clasSuffix
          print("  var \(key): [\(clase)] = []")
          newClass[clase] = Model(fist)
          //          defer {pringtOutMap(Model(fist), className: clase)}
        }else if let _ = va[0] as? String{
          print("  var \(key): [String] = []")
        }else{
          print("  var \(key): [NSNumber] = []")
        }
      }else{
        print("  var \(key): Any = []")
      }
    }else{
      print("  var \(key): NSNumber = 0")
    }
  }

  print("\n  override func mapping(map: Map) {\n    super.mapping(map: map)")

  for key in keys {
    print("    \(key) <- map[\"\(key)\"]")
  }
  print("  }")
  print("}")

  for (name, va) in newClass {
    pringtOutMap(va, className: name)
  }
}


print("请输入json字符串,然后回车\n\n\n")
let stdin = FileHandle.standardInput
if let input = NSString(data: stdin.availableData, encoding: String.Encoding.utf8.rawValue) as String? {
  josnToModel(json: input)
}else{
  print("输入有误")
  exit(0)
}


