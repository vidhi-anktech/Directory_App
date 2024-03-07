import 'package:flutter/material.dart';

class ASearchBar extends StatefulWidget {
  const ASearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();

  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchBarState extends State<ASearchBar> {
  bool _toggle = true;

  void _doToggle() => setState(() => _toggle = !_toggle);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Stack(children: [
        GestureDetector(
          onTap: _doToggle,
          child: const SizedBox(
              height: kToolbarHeight * 0.8,
              child: Row(
                children:  [
                  Icon(
                    Icons.location_on,
                    size: 25.0,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text("Tap to select your city",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),),
                ],
              )),
        ),
        AnimatedContainer(
          width: _toggle ? 0 : MediaQuery.of(context).size.width,
          transform: Matrix4.translationValues(_toggle ? MediaQuery.of(context).size.width : 0, 0, 0),
          duration: const Duration(seconds: 1),
          height: kToolbarHeight * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              width: 1,
              color: Colors.grey[600]!,
            ),
          ),
          child: TextField(
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              label: Text("Enter Your City"),
              labelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400
              ),
                prefixIcon: AnimatedOpacity(
                    duration: const Duration(seconds: 1),
                    opacity: _toggle ? 0 : 1,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                      size: 20,),
                      onPressed: _doToggle,
                    )),
                border: InputBorder.none),
          ),
        )
      ]),
    );
  }
}