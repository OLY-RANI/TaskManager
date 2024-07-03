
class TaskCountByStatusModel {
  String? sId;
  int? sum;

  TaskCountByStatusModel({this.sId, this.sum});

  TaskCountByStatusModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sum = json['sum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['sum'] = this.sum;
    return data;
  }
}
