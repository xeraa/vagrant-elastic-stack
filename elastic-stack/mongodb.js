// Run with: mongo /elastic-stack/mongodb.js
// It will generate some queries, so we have something to show in Packetbeat for MongoDB

db.test.drop()
db.test.createIndex({ "count": 1 }, { unique: true })

total = 50000
for(i=1; i<=total; i++){
    db.test.insert({ "count": i })
    db.test.find().sort({ "count": -1 }).limit(1)

    // Generate some errors and show the progress
    if(i%100 == 0){
        db.test.insert({ "count": 100 })
        print(i + " of " + total)
    }
};

