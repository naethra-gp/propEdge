// DropdownSearch<String>(
// selectedItem: _selectedFruit,
// mode: Mode.form,
// autoValidateMode: AutovalidateMode.onUserInteraction,
// items: (a, b) => _fruits,
// onChanged: (value) {
// setState(() {
// _selectedFruit = value.toString();
// });
// },
// validator: (value) {
// if (value == null || value.toString().isEmpty) {
// return 'Error';
// }
// return null;
// },
// popupProps: PopupProps.menu(
// showSearchBox: true,
// fit: FlexFit.tight,
// menuProps: MenuProps(elevation: 10),
// scrollbarProps: ScrollbarProps(
// thickness: 1,
// radius: Radius.circular(5),
// ),
// itemBuilder: (context, item, isDisabled, isSelected) {
// return ListTile(
// contentPadding: EdgeInsets.symmetric(horizontal: 10),
// title: Text(
// item,
// style: TextStyle(
// color: Colors.black87,
// fontWeight: FontWeight.bold,
// ),
// ),
// );
// },
// searchFieldProps: TextFieldProps(
// decoration: InputDecoration(
// contentPadding: EdgeInsets.symmetric(horizontal: 15),
// hintText: 'Search...',
// hintStyle: TextStyle(fontSize: 14),
// border: OutlineInputBorder(
// borderRadius: BorderRadius.circular(5.0),
// borderSide: const BorderSide(color: Color(0xff1980e3)),
// ),
// ),
// ),
// ),
// decoratorProps: DropDownDecoratorProps(
// decoration: InputDecoration(
// hintText: 'Search for a fruit',
// hintStyle: CustomTheme.formHintStyle,
// labelStyle: CustomTheme.formLabelStyle,
// errorStyle: CustomTheme.errorStyle,
// disabledBorder: OutlineInputBorder(
// borderRadius: BorderRadius.circular(5.0),
// borderSide: const BorderSide(color: Colors.grey),
// ),
// border: OutlineInputBorder(
// borderRadius: BorderRadius.circular(5.0),
// borderSide: const BorderSide(color: Color(0xff1980e3)),
// ),
// errorBorder: OutlineInputBorder(
// borderRadius: BorderRadius.circular(5.0),
// borderSide:
// const BorderSide(color: Colors.redAccent, width: 1.5),
// ),
// focusedBorder: const OutlineInputBorder(
// borderRadius: BorderRadius.all(Radius.circular(5.0)),
// borderSide: BorderSide(color: Color(0xff1980e3)),
// ),
// focusedErrorBorder: const OutlineInputBorder(
// borderRadius: BorderRadius.all(Radius.circular(5.0)),
// borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
// ),
// contentPadding: const EdgeInsets.all(10.0),
// isDense: false,
// ),
// ),
// ),
