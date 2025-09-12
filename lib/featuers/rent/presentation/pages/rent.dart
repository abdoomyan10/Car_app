import 'package:car_appp/core/utils/requests_status.dart';
import 'package:car_appp/core/utils/toaster.dart';
import 'package:car_appp/featuers/buy/data/model/car_model.dart';
import 'package:car_appp/featuers/rent/domain/use_cases/rent_car_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/services/dependencies.dart';
import '../bloc/rent_car_bloc.dart';

class RentScreen extends StatefulWidget {
  const RentScreen({super.key});

  @override
  State<RentScreen> createState() => _RentScreenState();
}

class _RentScreenState extends State<RentScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTimeRange? _selectedDateRange;
  final double _dailyPrice = 150;
  String? _selectedCarType;
  final String _selectedFuelType = 'بنزين';
  final int _selectedSeats = 4;

  List<String> carTypes = ['اقتصادية', 'عائلية', 'فاخرة', 'رياضية'];
  List<String> fuelTypes = ['بنزين', 'ديزل', 'هايبرد', 'كهرباء'];

  @override
  void initState() {
    super.initState();
    getIt<RentCarBloc>().add(GetRentCarEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('استئجار سيارة'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateRangePicker(),
                const SizedBox(height: 20),
                _buildSelectedRangeSummary(),
                const SizedBox(height: 12),
                _buildQuickFilters(),
                const SizedBox(height: 12),
                _buildAvailableCarsList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateRangePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
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
                            const Icon(
                              Icons.calendar_month,
                              color: Colors.grey,
                            ),
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
                            const Icon(
                              Icons.calendar_month,
                              color: Colors.grey,
                            ),
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
                    const Text(
                      'ر.س',
                      style: TextStyle(
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

  Widget _buildSelectedRangeSummary() {
    if (_selectedDateRange == null) return const SizedBox.shrink();

    final days = _selectedDateRange!.duration.inDays;
    final total = NumberFormat('#,###').format(days * _dailyPrice);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.blue),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'المدة: $days يوم - تقدير التكلفة: $total دولار',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickFilters() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final all = index == 0;
          final label = all ? 'الكل' : carTypes[index - 1];
          final selected = all
              ? _selectedCarType == null
              : _selectedCarType == label;

          return ChoiceChip(
            label: Text(label),
            selected: selected,
            onSelected: (_) {
              setState(() {
                _selectedCarType = all ? null : label;
              });
            },
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: 1 + carTypes.length,
      ),
    );
  }

  Widget _buildAvailableCarsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<RentCarBloc, RentCarState>(
        bloc: getIt<RentCarBloc>(),
        builder: (context, state) {
          if (state.rentCarStatus == RequestStatus.loading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (state.rentCarStatus == RequestStatus.failed) {
            return Center(
              child: IconButton.filled(
                onPressed: () {
                  getIt<RentCarBloc>().add(GetRentCarEvent());
                },
                icon: const Icon(Icons.refresh_rounded),
              ),
            );
          }

          final cars = _selectedCarType == null
              ? state.cars
              : state.cars.where((c) => c.carType == _selectedCarType).toList();

          if (cars.isEmpty) {
            return const Center(
              child: Text('لا يوجد سيارات متاحة للآجار حالياً'),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cars.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _buildCarItem(cars[index]),
          );
        },
      ),
    );
  }

  Widget _buildCarItem(CarListing car) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                car.imageUrls.isEmpty ? '' : car.imageUrls.first,
                width: 120,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: const Center(child: Icon(Icons.car_rental, size: 40)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.carModel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        car.city,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.people, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '$_selectedSeats مقاعد',
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${car.price} دولار/يوم',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => _showBookingDialog(car),
                  icon: const Icon(Icons.event_available, size: 18),
                  label: const Text('حجز'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    backgroundColor: Colors.green[50],
                    foregroundColor: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingDialog(CarListing car) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('حجز ${car.carModel}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_selectedDateRange != null) ...[
              Text('المدة: ${_selectedDateRange!.duration.inDays} أيام'),
              const SizedBox(height: 8),
              Text('السعر اليومي: ${car.price} دولار'),
              const SizedBox(height: 8),
              Text(
                'الإجمالي: ${car.price * _selectedDateRange!.duration.inDays} دولار',
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
                    _showPaymentOptions(car);
                  },
            child: const Text('تأكيد الحجز'),
          ),
        ],
      ),
    );
  }

  void _showPaymentOptions(CarListing car) {
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
            IgnorePointer(
              ignoring: true,
              child: _buildPaymentOption(Icons.credit_card, 'بطاقة ائتمان'),
            ),
            _buildPaymentOption(Icons.money, 'الدفع عند الاستلام'),
            IgnorePointer(
              ignoring: true,
              child: _buildPaymentOption(
                Icons.phone_android,
                'محفظة إلكترونية',
              ),
            ),
            const SizedBox(height: 20),
            BlocListener<RentCarBloc, RentCarState>(
              bloc: getIt<RentCarBloc>(),
              listener: (context, state) {
                if (state.rentNewCarStatus == RequestStatus.loading) {
                  Toaster.showLoading();
                } else {
                  Toaster.closeLoading();
                  if (state.rentNewCarStatus == RequestStatus.failed) {
                    Toaster.showToast('حدث خطأ، أعد المحاولة');
                  } else {
                    Navigator.pop(context);
                    _showBookingConfirmation();
                  }
                }
              },
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    getIt<RentCarBloc>().add(
                      RentNewCarEvent(
                        params: RentCarParams(
                          id: car.id,
                          status: 'rent_pending',
                          period: _selectedDateRange!.duration.inDays
                              .toString(),
                        ),
                      ),
                    );
                  },
                  child: const Text('تابع الدفع'),
                ),
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
      onTap: () {},
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
