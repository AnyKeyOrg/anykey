/*
 * Sets up serverless Stripe
 * checkout buttons for Donate page
 */

$(document).ready(function() {
  var stripe = Stripe('pk_test_51HV8FHBQehflyhkgtPssoP5TEbKCTA0kKBSCFQQ7CAZRNSbGa0hfEKGwnoch5W4l7kRx9jZAimVwYc3xjccQg5az00YJHpPBvx');

  var checkoutButton1 = document.getElementById('checkout-button-price_1HX8O0BQehflyhkgEfBifer2');
  if (checkoutButton1)
    checkoutButton1.addEventListener('click', function () {
      stripe.redirectToCheckout({
        lineItems: [{price: 'price_1HX8O0BQehflyhkgEfBifer2', quantity: 1}],
        mode: 'payment',
        successUrl: 'https://anykey.org/donate/success',
        cancelUrl: 'https://anykey.org/donate',
      })
    });

  var checkoutButton5 = document.getElementById('checkout-button-price_1HX7XRBQehflyhkgIejDYiKd');
  if (checkoutButton5)
    checkoutButton5.addEventListener('click', function () {
      stripe.redirectToCheckout({
        lineItems: [{price: 'price_1HX7XRBQehflyhkgIejDYiKd', quantity: 1}],
        mode: 'payment',
        successUrl: 'https://anykey.org/donate/success',
        cancelUrl: 'https://anykey.org/donate',
      })
    });

  var checkoutButton10 = document.getElementById('checkout-button-price_1HX8UPBQehflyhkgOzOXJVu1');
  if (checkoutButton10)
    checkoutButton10.addEventListener('click', function () {
      stripe.redirectToCheckout({
        lineItems: [{price: 'price_1HX8UPBQehflyhkgOzOXJVu1', quantity: 1}],
        mode: 'payment',
        successUrl: 'https://anykey.org/donate/success',
        cancelUrl: 'https://anykey.org/donate',
      })
    });

  var checkoutButton25 = document.getElementById('checkout-button-price_1HX8V8BQehflyhkgv5j8DBf6');
  if (checkoutButton25)
    checkoutButton25.addEventListener('click', function () {
      stripe.redirectToCheckout({
        lineItems: [{price: 'price_1HX8V8BQehflyhkgv5j8DBf6', quantity: 1}],
        mode: 'payment',
        successUrl: 'https://anykey.org/donate/success',
        cancelUrl: 'https://anykey.org/donate',
      })
    });

  var checkoutButton50 = document.getElementById('checkout-button-price_1HX8VlBQehflyhkgZtVDCFW0');
  if (checkoutButton50)
    checkoutButton50.addEventListener('click', function () {
      stripe.redirectToCheckout({
        lineItems: [{price: 'price_1HX8VlBQehflyhkgZtVDCFW0', quantity: 1}],
        mode: 'payment',
        successUrl: 'https://anykey.org/donate/success',
        cancelUrl: 'https://anykey.org/donate',
      })
    });

  var checkoutButton100 = document.getElementById('checkout-button-price_1HX8WLBQehflyhkgcGy10Lsd');
  if (checkoutButton100)
    checkoutButton100.addEventListener('click', function () {
      stripe.redirectToCheckout({
        lineItems: [{price: 'price_1HX8WLBQehflyhkgcGy10Lsd', quantity: 1}],
        mode: 'payment',
        successUrl: 'https://anykey.org/donate/success',
        cancelUrl: 'https://anykey.org/donate',
      })
    });

  var checkoutButton500 = document.getElementById('checkout-button-price_1HX8WzBQehflyhkgk5u79eb4');
  if (checkoutButton500)
    checkoutButton500.addEventListener('click', function () {
      stripe.redirectToCheckout({
        lineItems: [{price: 'price_1HX8WzBQehflyhkgk5u79eb4', quantity: 1}],
        mode: 'payment',
        successUrl: 'https://anykey.org/donate/success',
        cancelUrl: 'https://anykey.org/donate',
      })
    });

});