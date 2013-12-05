mongoid_sync_with_deserialization
=================================
解决JSON同步数据时，不支持Time等类型序列化的问题。


TODO
---------------------------------
需要修改fields，才能ActiveModel公用

参考
---------------------------------
Store Data type in JSON, MongoDB has a solution. http://markembling.info/2011/07/json-date-time

```text
MongoDB shell version: 1.8.2
connecting to: test
> db.tests.insert({'ts':new Date()})
> db.tests.find()
{ "_id" : ObjectId("4e1f671d671bd7812369551e"), "ts" : ISODate("2011-07-14T22:01:01.947Z") }
```
