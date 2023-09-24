class UnbordingContent {
  String? image;
  String? title;
  String? discription;

  UnbordingContent(this.title, this.image, this.discription);
}

List<UnbordingContent> numberContent = [
  UnbordingContent(
      'คาร์บอนฟุตพริ้นท์',
      'https://firebasestorage.googleapis.com/v0/b/cos4105napoo.appspot.com/o/overView%2FallCarbon.png?alt=media&token=572e7a90-8d00-4fe6-9c99-e18e0716dec8',
      "หมายถึง ปริมาณก๊าซเรือนกระจกที่ปล่อยออกมาจากผลิตภัณฑ์แต่ละหน่วย ตลอดวัฎจักรชีวิตของผลิตภัณฑ์"),
  UnbordingContent(
      'เครื่องหมายบนสินค้า',
      'https://firebasestorage.googleapis.com/v0/b/cos4105napoo.appspot.com/o/overView%2FlableCarbon.jpg?alt=media&token=c7268698-9071-4630-8252-6cdf53a9ac8c',
      " จะติดบนสินค้าหรือผลิตภัณฑ์ต่าง ๆ นั้น เป็นการแสดงข้อมูลให้ผู้บริโภคได้ทราบว่า ตลอดวัฏจักรชีวิตของผลิตภัณฑ์เหล่านั้นมีการปล่อยก๊าซเรือนกระจกออกมาปริมาณเท่าไหร่ "),
  UnbordingContent(
      'การคำนวณ',
      'https://firebasestorage.googleapis.com/v0/b/cos4105napoo.appspot.com/o/overView%2FcalCarbon.png?alt=media&token=0e981032-329d-408e-81d3-8df62fe628db',
      "คาร์บอนฟุตพริ้นท์คำนวณออกมาเป็น “ตัน” หรือ “กิโลกรัม” ของก๊าซคาร์บอนไดออกไซด์เทียบเท่า"),
];
