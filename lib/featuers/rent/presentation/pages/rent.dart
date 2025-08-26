import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class RentScreen extends StatefulWidget {
  const RentScreen({super.key});

  @override
  State<RentScreen> createState() => _RentScreenState();
}

class _RentScreenState extends State<RentScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTimeRange? _selectedDateRange;
  final double _dailyPrice = 150;
  String _selectedCarType = 'اقتصادية';
  String _selectedFuelType = 'بنزين';
  bool _withDriver = false;
  int _selectedSeats = 4;

  List<String> carTypes = ['اقتصادية', 'عائلية', 'فاخرة', 'رياضية'];
  List<String> fuelTypes = ['بنزين', 'ديزل', 'هايبرد', 'كهرباء'];
  String _calculateTotalPrice() {
    if (_selectedDateRange == null) return '0';
    final days = _selectedDateRange!.duration.inDays;
    return NumberFormat('#,###').format(days * _dailyPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('استئجار سيارة'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // محدد التاريخ والوقت
              _buildDateRangePicker(),
              const SizedBox(height: 20),

              // فلترة سريعة

              // قائمة السيارات المتاحة
              _buildAvailableCarsList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomSummary(),
    );
  }

  Widget _buildDateRangePicker() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.calendar_today, size: 20),
                SizedBox(width: 8),
                Text(
                  'حدد فترة التأجير',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDateRange(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedDateRange == null
                                ? 'من تاريخ'
                                : DateFormat(
                                    'yyyy/MM/dd',
                                  ).format(_selectedDateRange!.start),
                            style: TextStyle(
                              color: _selectedDateRange == null
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                          const Icon(Icons.calendar_month, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.arrow_forward, color: Colors.grey),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDateRange(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedDateRange == null
                                ? 'إلى تاريخ'
                                : DateFormat(
                                    'yyyy/MM/dd',
                                  ).format(_selectedDateRange!.end),
                            style: TextStyle(
                              color: _selectedDateRange == null
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                          const Icon(Icons.calendar_month, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_selectedDateRange != null) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${_selectedDateRange!.duration.inDays} أيام',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    ' ر.س',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableCarsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'السيارات المتاحة',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 5,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) => _buildCarItem(index),
        ),
      ],
    );
  }

  Widget _buildCarItem(int index) {
    final cars = [
      {
        'model': 'سيرانتو',
        'price': 100,
        'type': 'عائلية',
        'image': 'assets/sorento.png',
      },
      {
        'model': ' mercedes G class',
        'price': 300,
        'type': 'فاخرة',
        'image': 'assets/gcalss.png',
      },
      {
        'model': 'BMW X5 ',
        'price': 200,
        'type': 'رياضية',
        'image': 'assets/bmw.png',
      },
      {
        'model': 'نيسان باترول',
        'price': 250,
        'type': 'SUV',
        'image': 'assets/nissan.png',
      },
      {
        'model': '  verna ',
        'price': 50,
        'type': 'اقتصادية',
        'image': 'assets/verna.png',
      },
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                cars[index]['image'] as String,
                width: 100,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 100,
                  height: 80,
                  color: Colors.grey[200],
                  child: const Icon(Icons.car_rental, size: 40),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cars[index]['model'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cars[index]['type'] as String,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.people, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${_selectedSeats} مقاعد',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.local_gas_station,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _selectedFuelType,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  '${cars[index]['price']} دولار/يوم',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => _showBookingDialog(cars[index]),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    backgroundColor: Colors.green[50],
                    foregroundColor: Colors.green,
                  ),
                  child: const Text('حجز'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSummary() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_selectedDateRange != null)
                    Text(
                      '${_selectedDateRange!.duration.inDays} أيام',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  const Text(
                    'إجمالي الحجز',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _selectedDateRange == null ? null : () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('تابع الحجز'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _selectedDateRange,

      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      setState(() => _selectedDateRange = picked);
    }
  }

  void _showBookingDialog(Map<String, dynamic> car) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('حجز ${car['model']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_selectedDateRange != null) ...[
              Text('المدة: ${_selectedDateRange!.duration.inDays} أيام'),
              const SizedBox(height: 8),
              Text('السعر اليومي: ${car['price']} ر.س'),
              const SizedBox(height: 8),
              Text(
                'الإجمالي: ${car['price'] * _selectedDateRange!.duration.inDays} ر.س',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ] else
              const Text(
                'الرجاء تحديد مدة الاستئجار أولاً',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: _selectedDateRange == null
                ? null
                : () {
                    Navigator.pop(context);
                    _showPaymentOptions();
                  },
            child: const Text('تأكيد الحجز'),
          ),
        ],
      ),
    );
  }

  void _showPaymentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'اختر طريقة الدفع',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildPaymentOption(Icons.credit_card, 'بطاقة ائتمان'),
            _buildPaymentOption(Icons.money, 'الدفع عند الاستلام'),
            _buildPaymentOption(Icons.phone_android, 'محفظة إلكترونية'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showBookingConfirmation();
                },
                child: const Text('تابع الدفع'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // اختيار طريقة الدفع
      },
    );
  }

  void _showBookingConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تم الحجز بنجاح'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 50),
            SizedBox(height: 16),
            Text('سيتم إرسال تفاصيل الحجز إلى بريدك الإلكتروني'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }
}
