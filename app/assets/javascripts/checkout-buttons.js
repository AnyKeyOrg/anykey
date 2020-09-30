/*
 * Sets up serverless Stripe
 * checkout buttons
 */

$(document).ready(function() {
  var stripe = Stripe('pk_test_51HV8FHBQehflyhkgtPssoP5TEbKCTA0kKBSCFQQ7CAZRNSbGa0hfEKGwnoch5W4l7kRx9jZAimVwYc3xjccQg5az00YJHpPBvx');

  var checkoutButton1 = document.getElementById('checkout-button-price_1HX8O0BQehflyhkgEfBifer2');
  checkoutButton1.addEventListener('click', function () {
    stripe.redirectToCheckout({
      lineItems: [{price: 'price_1HX8O0BQehflyhkgEfBifer2', quantity: 1}],
      mode: 'payment',
      successUrl: 'https://anykey.org/success',
      cancelUrl: 'https://anykey.org/canceled',
    })
  });

  var checkoutButton5 = document.getElementById('checkout-button-price_1HX7XRBQehflyhkgIejDYiKd');
  checkoutButton5.addEventListener('click', function () {
    stripe.redirectToCheckout({
      lineItems: [{price: 'price_1HX7XRBQehflyhkgIejDYiKd', quantity: 1}],
      mode: 'payment',
      successUrl: 'https://anykey.org/success',
      cancelUrl: 'https://anykey.org/canceled',
    })
  });

  var checkoutButton10 = document.getElementById('checkout-button-price_1HX8UPBQehflyhkgOzOXJVu1');
  checkoutButton10.addEventListener('click', function () {
    stripe.redirectToCheckout({
      lineItems: [{price: 'price_1HX8UPBQehflyhkgOzOXJVu1', quantity: 1}],
      mode: 'payment',
      successUrl: 'https://anykey.org/success',
      cancelUrl: 'https://anykey.org/canceled',
    })
  });
  
  var checkoutButton25 = document.getElementById('checkout-button-price_1HX8V8BQehflyhkgv5j8DBf6');
  checkoutButton25.addEventListener('click', function () {
    stripe.redirectToCheckout({
      lineItems: [{price: 'price_1HX8V8BQehflyhkgv5j8DBf6', quantity: 1}],
      mode: 'payment',
      successUrl: 'https://anykey.org/success',
      cancelUrl: 'https://anykey.org/canceled',
    })
  });
  
  var checkoutButton50 = document.getElementById('checkout-button-price_1HX8VlBQehflyhkgZtVDCFW0');
  checkoutButton50.addEventListener('click', function () {
    stripe.redirectToCheckout({
      lineItems: [{price: 'price_1HX8VlBQehflyhkgZtVDCFW0', quantity: 1}],
      mode: 'payment',
      successUrl: 'https://anykey.org/success',
      cancelUrl: 'https://anykey.org/canceled',
    })
  });
  
  var checkoutButton100 = document.getElementById('checkout-button-price_1HX8WLBQehflyhkgcGy10Lsd');
  checkoutButton100.addEventListener('click', function () {
    stripe.redirectToCheckout({
      lineItems: [{price: 'price_1HX8WLBQehflyhkgcGy10Lsd', quantity: 1}],
      mode: 'payment',
      successUrl: 'https://anykey.org/success',
      cancelUrl: 'https://anykey.org/canceled',
    })
  });
  
  var checkoutButton500 = document.getElementById('checkout-button-price_1HX8WzBQehflyhkgk5u79eb4');
  checkoutButton500.addEventListener('click', function () {
    stripe.redirectToCheckout({
      lineItems: [{price: 'price_1HX8WzBQehflyhkgk5u79eb4', quantity: 1}],
      mode: 'payment',
      successUrl: 'https://anykey.org/success',
      cancelUrl: 'https://anykey.org/canceled',
    })
  });
  
});