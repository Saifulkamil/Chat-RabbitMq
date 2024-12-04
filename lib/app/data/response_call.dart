class ResponseCall<T> {
  Status? status;
  T? data;
  String? message;

  ResponseCall.loading(this.message) : status = Status.loading;
  ResponseCall.completed(this.data) : status = Status.completed;
  ResponseCall.error(this.message) : status = Status.error;
  ResponseCall.iddle(this.message) : status = Status.iddle;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum Status { loading, completed, error, iddle }
