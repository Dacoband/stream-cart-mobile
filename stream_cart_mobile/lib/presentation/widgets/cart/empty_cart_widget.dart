import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyCartWidget extends StatelessWidget {
  final VoidCallback? onContinueShopping;

  const EmptyCartWidget({
    super.key,
    this.onContinueShopping,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Spacer(flex: 2),
              SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: SvgPicture.string(
                    emptyCartIllustration,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
              const Spacer(flex: 2),
              ErrorInfo(
                title: "Giỏ hàng trống",
                description: "Hãy thêm sản phẩm vào giỏ hàng để bắt đầu mua sắm",
                btnText: "Tiếp tục mua sắm",
                press: onContinueShopping ?? () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorInfo extends StatelessWidget {
  const ErrorInfo({
    super.key,
    required this.title,
    required this.description,
    this.button,
    this.btnText,
    required this.press,
  });

  final String title;
  final String description;
  final Widget? button;
  final String? btnText;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 40),
            button ??
                ElevatedButton(
                  onPressed: press,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  child: Text(
                    btnText ?? "Retry".toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

const emptyCartIllustration = '''
<svg width="1080" height="1080" viewBox="0 0 1080 1080" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M823.7 629.49C845.367 628.317 867.13 627.02 888.99 625.6" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M270.59 630.37C275.37 605.51 297.8 590.76 329.32 590.76C330.653 590.76 331.957 590.787 333.23 590.84L328.48 633.63L270.59 630.37Z" fill="#ABABAB"/>
<path d="M181 625.6C311 635.293 445.63 639.263 584.89 637.51" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M827.45 706.11C848.26 706.11 868.82 706.11 888.98 706.03" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M181 736.4C229.46 708.72 393.36 704.65 578.41 704.9" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M373 707.89C338.16 723.643 315.627 739.393 305.4 755.14" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M404.2 707.61C369.93 720.47 343.56 737.61 339.2 767.11" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M552.71 538.26C562.413 534.954 570.946 528.899 577.27 520.832C583.595 512.764 587.438 503.033 588.333 492.822C589.227 482.61 587.135 472.359 582.31 463.315C577.484 454.271 570.135 446.824 561.155 441.881C552.175 436.938 541.951 434.711 531.729 435.472C521.507 436.233 511.726 439.949 503.577 446.167C495.427 452.385 489.261 460.838 485.828 470.496C482.395 480.155 481.843 490.603 484.24 500.57C512.9 509.66 537.72 521 552.71 538.26Z" fill="#ABABAB"/>
<path d="M328.48 634C332.57 541.4 372.72 478.56 475.88 499C554.71 517.43 584.88 562 584.88 637.86" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M460.08 495.79C456.544 480.027 457.667 463.577 463.312 448.441C468.958 433.305 478.882 420.137 491.876 410.54C504.871 400.943 520.375 395.331 536.502 394.387C552.629 393.443 568.682 397.208 582.707 405.224C596.733 413.24 608.125 425.16 615.498 439.534C622.87 453.908 625.905 470.115 624.232 486.182C622.559 502.25 616.25 517.484 606.075 530.031C595.899 542.578 582.296 551.896 566.92 556.85" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M215.23 628C218.555 615.278 224.533 603.403 232.771 593.153C241.009 582.904 251.321 574.513 263.03 568.53C274.739 562.546 287.582 559.107 300.714 558.436C313.846 557.766 326.972 559.88 339.23 564.64" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M616 537.66C738.34 483.2 826.26 519.61 840.47 637.75C846.47 685.67 845.04 728.28 840.47 774.75C835.25 798.4 777 795.62 767.78 774.75C762.46 768.88 762.18 709.75 767.78 686.69C768.33 684.42 764.85 683.21 763.06 684.81C746.88 699.31 701.53 699.51 683.25 683.46C682.858 683.116 682.377 682.888 681.863 682.803C681.348 682.717 680.82 682.777 680.337 682.975C679.855 683.174 679.438 683.503 679.132 683.927C678.827 684.35 678.646 684.85 678.61 685.37C682.89 716.67 683.61 746.86 677.03 774.76C669.52 804.01 605.03 801.12 601.94 774.76C595.15 741.76 603.79 679.21 601.94 637.94C595.46 597.83 600.63 564.6 616 537.66Z" fill="#D3D3D3"/>
<path d="M599 537.66C721.34 483.2 809.26 519.61 823.47 637.75C829.47 685.67 828.04 728.28 823.47 774.75C818.25 798.4 760 795.62 750.78 774.75C745.46 768.88 745.18 709.75 750.78 686.69C751.33 684.42 747.85 683.21 746.06 684.81C729.88 699.31 684.53 699.51 666.25 683.46C665.858 683.116 665.377 682.888 664.863 682.803C664.348 682.717 663.82 682.777 663.337 682.975C662.855 683.174 662.437 683.503 662.132 683.927C661.827 684.35 661.646 684.85 661.61 685.37C665.89 716.67 666.61 746.86 660.03 774.76C652.52 804.01 588.03 801.12 584.94 774.76C574.55 738.31 577.08 673.19 584.94 637.94" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M503.87 705.89C497.73 727.08 497.3 756.44 503.87 771.06C511.68 796.32 572.36 795.63 583.87 771.06" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M688.66 706.31C682.52 728.31 683.26 752.64 688.66 773.8C694.72 794.11 741.72 788.28 749.3 772.33" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M494.25 553.29C490.917 567.337 481.25 574.313 465.25 574.22" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M409.34 606.22C403.64 619.48 392.897 624.667 377.11 621.78" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M450.67 636.78L436.12 615.65C431.86 610.74 433.74 602.07 440.31 596.37C446.87 590.67 455.72 590.02 459.98 594.93L487.46 620.55C491.02 624.65 486.86 631.62 481.57 637.13" fill="#0E0E0E"/>
<path d="M516.31 631.74L508.95 637.06" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M239.38 657.85H377.11" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M353.02 671.04H471.27" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M488.79 657.85H520.41" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M688.105 445.974C688.581 445.974 688.947 446.102 689.204 446.358C689.46 446.615 689.588 446.944 689.588 447.347C689.588 447.75 689.442 448.079 689.149 448.336C688.892 448.592 688.545 448.72 688.105 448.72H668.554C668.005 448.72 667.565 448.574 667.236 448.281C666.943 447.988 666.796 447.622 666.796 447.182C666.796 446.67 666.979 446.212 667.346 445.809L684.59 424.775H668.224C667.785 424.775 667.437 424.665 667.181 424.445C666.924 424.189 666.796 423.86 666.796 423.457C666.796 423.054 666.924 422.725 667.181 422.468C667.437 422.212 667.785 422.084 668.224 422.084H687.227C687.776 422.084 688.215 422.23 688.545 422.523C688.874 422.816 689.039 423.182 689.039 423.622C689.039 424.098 688.856 424.537 688.49 424.94L671.245 445.974H688.105Z" fill="#0E0E0E"/>
<path d="M745.633 397.893C746.267 397.893 746.754 398.064 747.096 398.405C747.437 398.746 747.608 399.185 747.608 399.721C747.608 400.258 747.413 400.697 747.023 401.038C746.681 401.379 746.218 401.55 745.633 401.55H719.595C718.864 401.55 718.279 401.355 717.84 400.965C717.45 400.575 717.255 400.087 717.255 399.502C717.255 398.819 717.498 398.21 717.986 397.674L740.952 369.661H719.156C718.571 369.661 718.108 369.515 717.767 369.222C717.425 368.881 717.255 368.442 717.255 367.906C717.255 367.369 717.425 366.93 717.767 366.589C718.108 366.248 718.571 366.077 719.156 366.077H744.463C745.194 366.077 745.779 366.272 746.218 366.662C746.657 367.052 746.876 367.54 746.876 368.125C746.876 368.759 746.632 369.344 746.145 369.88L723.179 397.893H745.633Z" fill="#0E0E0E"/>
<path d="M802.206 339.88C802.891 339.88 803.417 340.064 803.786 340.433C804.155 340.802 804.339 341.276 804.339 341.855C804.339 342.434 804.128 342.908 803.707 343.277C803.338 343.646 802.838 343.83 802.206 343.83H774.082C773.292 343.83 772.66 343.619 772.186 343.198C771.765 342.777 771.554 342.25 771.554 341.618C771.554 340.881 771.817 340.222 772.344 339.643L797.15 309.386H773.608C772.976 309.386 772.476 309.228 772.107 308.912C771.738 308.543 771.554 308.069 771.554 307.49C771.554 306.911 771.738 306.437 772.107 306.068C772.476 305.699 772.976 305.515 773.608 305.515H800.942C801.732 305.515 802.364 305.726 802.838 306.147C803.312 306.568 803.549 307.095 803.549 307.727C803.549 308.412 803.286 309.044 802.759 309.623L777.953 339.88H802.206Z" fill="#0E0E0E"/>
<path d="M680.77 704.89L747.94 705.89" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';