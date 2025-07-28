import 'package:flutter/material.dart';
import 'package:prop_edge/app_utils/alert_service.dart';
import 'package:prop_edge/app_utils/app/app_bar.dart';
import '../../app_services/local_db/local_services/property_details_services.dart';
import 'forms/index.dart';

class SiteVisitFormPage extends StatefulWidget {
  final String propId;
  const SiteVisitFormPage({super.key, required this.propId});

  @override
  State<SiteVisitFormPage> createState() => _SiteVisitFormPageState();
}

class _SiteVisitFormPageState extends State<SiteVisitFormPage> {
  final AlertService _alertService = AlertService();
  final ScrollController _scrollController = ScrollController();
  final PropertyDetailsServices _propertyServices = PropertyDetailsServices();

  List<MenuItem> _menuItems = [];
  List _property = [];
  bool _showMeasurementForms = false;
  // bool resSelected = false;
  int _selectedFormIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _fetchPropertyDetails();
    _buildMenuItems();
  }

  Future<void> _fetchPropertyDetails() async {
    _property = await _propertyServices.readById(widget.propId);
    final propertyType = _property[0]['PropertyType'];
    _showMeasurementForms =
        propertyType == '953' || propertyType == '954' || propertyType == '952';
    setState(() {});
  }

  void _selectForm(int index) {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {
      _selectedFormIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          final confirm = await _alertService.confirmAlert(
            context,
            null,
            "Do you want to exit from this form?",
          );
          if (confirm == true && context.mounted) {
            Navigator.pushReplacementNamed(context, 'mainPage', arguments: 2);
          }
        },
        child: Scaffold(
          appBar: AppBarWidget(title: 'Site Visit Form', action: false),
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Wrap(
                  spacing: 0,
                  children: _menuItems
                      .map((item) => _buildTopMenuButton(item))
                      .toList(),
                ),
                const Divider(
                  color: Colors.black,
                  indent: 15,
                  endIndent: 15,
                ),
                if (_menuItems.isNotEmpty)
                  Center(child: _menuItems[_selectedFormIndex].child),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _buildMenuItems() {
    _menuItems = [
      MenuItem(
        item: "Customer",
        child: CustomerForm(
          propId: widget.propId,
          buttonClicked: () => _selectForm(1),
        ),
      ),
      MenuItem(
        item: "Property",
        child: PropertyForm(
          propId: widget.propId,
          buttonClicked: () => _selectForm(2),
          onVisibility: (value) {
            setState(() {
              _showMeasurementForms = value;
              // resSelected = value;
              _buildMenuItems();
            });
          },
        ),
      ),
      MenuItem(
        item: "Area",
        child: AreaForm(
          propId: widget.propId,
          buttonClicked: () => _selectForm(3),
          onVisibility: _showMeasurementForms,
        ),
      ),
      MenuItem(
        item: "Occupancy",
        child: OccupancyForm(
          propId: widget.propId,
          buttonClicked: () => _selectForm(4),
        ),
      ),
      MenuItem(
        item: "Boundary",
        child: BoundaryForm(
          propId: widget.propId,
          buttonClicked: () => _selectForm(5),
        ),
      ),
      if (_showMeasurementForms)
        MenuItem(
          item: "Measurement",
          child: MeasurementForm(
            propId: widget.propId,
            buttonClicked: () => _selectForm(6),
          ),
        ),
      if (_showMeasurementForms)
        MenuItem(
          item: "Calculator",
          child: CalculatorForm(
            propId: widget.propId,
            buttonClicked: () => _selectForm(7),
          ),
        ),
      MenuItem(
        item: "Comments",
        child: CommentsForm(
          propId: widget.propId,
          buttonClicked: () => _selectForm(!_showMeasurementForms ? 6 : 8),
        ),
      ),
      MenuItem(
        item: "Uploads",
        child: UploadForm(
          propId: widget.propId,
          buttonClicked: () => _selectForm(!_showMeasurementForms ? 7 : 9),
          onVisibility: _showMeasurementForms,
        ),
      ),
    ];

    // Reset _selectedFormIndex if it exceeds the new length of _menuItems
    if (_selectedFormIndex >= _menuItems.length) {
      _selectedFormIndex = 0;
    }

    setState(() {});
  }

  Widget _buildTopMenuButton(MenuItem item) {
    final isSelected = _menuItems.indexOf(item) == _selectedFormIndex;
    return TextButton(
      onPressed: () {
        final index = _menuItems.indexOf(item);
        if (index != -1) {
          // Ensure the index is valid
          _selectForm(index);
        }
      },
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        backgroundColor:
            isSelected ? Theme.of(context).primaryColor : Colors.transparent,
      ),
      child: Text(
        item.item,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
          color: isSelected ? Colors.white : Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

class MenuItem {
  final String item;
  final Widget child;

  MenuItem({
    required this.item,
    required this.child,
  });
}
