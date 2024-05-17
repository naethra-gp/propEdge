class ReimbursementRequestModel {
  String? id;
  String? expenseDate;
  String? natureOfExpense;
  String? noOfDays;
  String? travelAllowance;
  String? totalAmount;
  String? expenseComment;
  String? billName;
  String? billPath;
  String? isActive;
  String? syncStatus;
  String? billBase64String;

  ReimbursementRequestModel({
    this.id,
    this.expenseDate,
    this.natureOfExpense,
    this.noOfDays,
    this.travelAllowance,
    this.totalAmount,
    this.expenseComment,
    this.billName,
    this.billPath,
    this.isActive,
    this.syncStatus,
    this.billBase64String,
  });

  ReimbursementRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    expenseDate = json['ExpenseDate'];
    natureOfExpense = json['NatureOfExpense'];
    noOfDays = json['NoOfDays'];
    travelAllowance = json['TravelAllowance'];
    totalAmount = json['TotalAmount'];
    expenseComment = json['ExpenseComment'];
    billName = json['BillName'];
    billPath = json['BillPath'];
    isActive = json['IsActive'];
    syncStatus = json['SyncStatus'];
    billBase64String = json['BillBase64String'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['ExpenseDate'] = expenseDate;
    data['NatureOfExpense'] = natureOfExpense;
    data['NoOfDays'] = noOfDays;
    data['TravelAllowance'] = travelAllowance;
    data['TotalAmount'] = totalAmount;
    data['ExpenseComment'] = expenseComment;
    data['BillName'] = billName;
    data['BillPath'] = billPath;
    data['IsActive'] = isActive;
    data['SyncStatus'] = syncStatus;
    data['BillBase64String'] = billBase64String;
    return data;
  }
}
