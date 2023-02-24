class Device{
  String id; /// Device's mac address
  String displayName;
  DateTime connectedDate;
  DateTime lastUseDate;

  Device({required this.id, required this.displayName, required this.connectedDate, required this.lastUseDate});
}
