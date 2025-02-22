async function updateTokens(action) {
    const distance = parseFloat(document.getElementById("distance").textContent);
    const emissions = parseFloat(document.getElementById("emissions").textContent);

    const response = await fetch("/tokens", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ distance, emissions, action }),
    });

    const data = await response.json();
    document.getElementById("tokens").textContent = data.tokens;
}

// Gain Tokens
document.getElementById("gainTokens").addEventListener("click", () => updateTokens("gain"));

// Redeem Tokens
document.getElementById("redeemTokens").addEventListener("click", () => updateTokens("redeem"));
