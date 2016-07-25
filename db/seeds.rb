require 'faker'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
ISO3166::Country.all.map do |item|
  Country.create!(name: item[0], alpha2: item[1])
end

if Rails.env == 'development' || Rails.env == 'production' 
  Admin.create!(email: 'admin@mail.com', password: '12345678',
                password_confirmation: '12345678')

  FactoryGirl.create(:customer, 
    firstname: "Vadim", lastname: "Tsvid",
    email: 'vad_1989@mail.ru', password: '12345678',
    password_confirmation: '12345678',
    provider: "facebook", uid: "580001345483302")

  FactoryGirl.create(:customer, 
    firstname: 'Cus', lastname: 'Tomer', 
    email: 'mail@mail.com', password: '12345678',
    password_confirmation: '12345678', provider: '', uid: '')

  coupons = FactoryGirl.create_list(:coupon, 5)

  author = FactoryGirl.create(:author,
    firstname: 'Dalai',
    lastname: 'Lama',
    biography: "The 14th Dalai Lama (religious name: Tenzin Gyatso, shortened from Jetsun Jamphel Ngawang Lobsang Yeshe Tenzin Gyatso, born Lhamo Thondup, 6 July 1935) is the current Dalai Lama. The 14th Dalai Lama was born in Taktser village (administratively in Qinghai province, Republic of China), Amdo, Tibet, and was selected as the tulku of the 13th Dalai Lama in 1937 and formally recognized as the 14th Dalai Lama at a public declaration near the town of Bumchen in 1939. His enthronement ceremony as the Dalai Lama was held in Lhasa on February 22, 1940, and he eventually assumed full temporal (political) power over Tibet on 17 November 1950, at the age of 15, after China's invasion of Tibet. The Gelug school's government administered an area roughly corresponding to the Tibet Autonomous Region just as the nascent People's Republic of China wished to assert central control over it. During the 1959 Tibetan uprising, the Dalai Lama fled to India, where he currently lives as a political refugee. He has since traveled the world, advocating for the welfare of Tibetans, teaching Tibetan Buddhism, investigating the interface between Buddhism and science and talking about the importance of compassion as the source of a happy life. Around the world, institutions face pressure from China not to accept him. Various governments have likewise been pressured to not meet the Dalai Lama: In South Africa, he was denied a visa for Desmond Tutu's birthday celebrations, Australia's Prime Minister refused to meet with him, and ministers in the United Kingdom were also pressured to not meet with him.")

  best_category = FactoryGirl.create :category, title: 'bestsellers'

  best_books = Array.new
  
  best_books[0] = FactoryGirl.create(:book,
    title: 'How to see yourself as you really are',
    description: "According to His Holiness the Dalai Lama, we each possess the ability to achieve happiness and a meaningful life, but the key to realizing that goal is self-knowledge. In How to See Yourself As You Really Are, the world's foremost Buddhist leader and recipient of the Nobel Peace Prize shows readers how to recognize and dispel misguided notions of self and embrace the world from a more realistic -- and loving -- perspective. Through illuminating explanations and step-by-step exercises, His Holiness helps readers to see the world as it actually exists, and explains how, through the interconnection of meditative concentration and love, true altruistic enlightenment is attained.\nEnlivened by personal anecdotes and intimate accounts of the Dalai Lama's own life experiences, How to See Yourself As You Really Are is an inspirational and empowering guide that can be read and enjoyed by anyone seeking spiritual fulfillment.",
    price: 9.46,
    books_in_stock: rand(20..100),
    author_id: author.id,
    images: File.open(Rails.root + "app/assets/images/books-images/41OgOIZBVPL.jpg"))

  best_books[1] = FactoryGirl.create(:book,
    title: 'How to Practice: The Way to a Meaningful Life',
    description: "As human beings, we all share the desire for happiness and meaning in our lives. According to His Holiness the Dalai Lama, the ability to find true fulfillment lies within each of us. In this very special book, the spiritual and temporal leader of Tibet, Nobel Prize winner, and bestselling author helps readers embark upon the path to enlightenment with a stunning illumination of the timeless wisdom and an easy-access reference for daily practice.\nDivided into a series of distinct steps that will lead spiritual seekers toward enlightenment, How to Practice is a constant companion in the quest to practice morality, meditation, and wisdom. This accessible book will guide you toward opening your heart, refraining from doing harm, and maintiaining mentaltranquility as the Dalai Lama shows you how to overcome everyday obstacles, from feelings of anger and mistrust to jealousy, insecurity, and counterproductive thinking. Imbued with His Holiness' vivacious spirit and sense of playfulness, How to Practice offers sage and practical insight into the human psyche and into the deepest aspirations that bind us all together.",
    price: 10.29,
    books_in_stock: rand(20..100),
    author_id: author.id,
    images: File.open(Rails.root + "app/assets/images/books-images/4133VHHWJ1L.jpg"))

  best_books[2] = FactoryGirl.create(:book,
    title: 'Beyond Religion: Ethics for a Whole World',
    description: "\“A book that brings people together on the firm grounds of shared values, reminding us why the Dalai Lama is still one of the most important religious figures in the world.\” —Huffington Post, \“Best Religious Books of 2011\”\nTen years ago, in the best-selling Ethics for a New Millennium, His Holiness the Dalai Lama first proposed an approach to ethics based on universal rather than religious principles. With Beyond Relgion, he returns to the conversation at his most outspoken, elaborating and deepening his vision for the nonreligious way—a path to lead an ethical, happy, and spiritual life. Transcending the religion wars, he outlines a system of ethics for our shared world, one that makes a stirring appeal for a deep appreciation of our common humanity, offering us all a road map for improving human life on individual, community, and global levels.\n\“Cogent and fresh . . . This ethical vision is needed as we face the global challenges of technological progress, peace, environmental destruction, greed, science, and educating future generations.\” —Spirtuality & Practice",
    price: 8.95,
    books_in_stock: rand(20..100),
    author_id: author.id,
    images: File.open(Rails.root + "app/assets/images/books-images/51-W1m2z4WL.jpg"))

  best_category.books << best_books
  

  other_category = FactoryGirl.create :category, title: 'other'

  other_books = Array.new
  
  other_books[0] = FactoryGirl.create(:book,
    title: 'The Universe in a Single Atom: The Convergence of Science and Spirituality',
    description: "Galileo, Copernicus, Newton, Niels Bohr, Einstein. Their insights shook our perception of who we are and where we stand in the world, and in their wake have left an uneasy coexistence: science vs. religion, faith vs. empirical inquiry. Which is the keeper of truth? Which is the true path to understanding reality?\nAfter forty years of study with some of the greatest scientific minds, as well as a lifetime of meditative, spiritual, and philosophic study, the Dalai Lama presents a brilliant analysis of why all avenues of inquiry—scientific as well as spiritual—must be pursued in order to arrive at a complete picture of the truth. Through an examination of Darwinism and karma, quantum mechanics and philosophical insight into the nature of reality, neurobiology and the study of consciousness, the Dalai Lama draws significant parallels between contemplative and scientific examinations of reality.\nThis breathtakingly personal examination is a tribute to the Dalai Lama’s teachers—both of science and spirituality. The legacy of this book is a vision of the world in which our different approaches to understanding ourselves, our universe, and one another can be brought together in the service of humanity.",
    price: 10.49,
    books_in_stock: rand(20..100),
    author_id: author.id,
    images: File.open(Rails.root + "app/assets/images/books-images/51AdUxb4frL.jpg"))

  other_books[1] = FactoryGirl.create(:book,
  title: 'The Art of Happiness in a Troubled World',
  description: "Blending common sense and modern psychiatry, The Art of Happiness in a Troubled World applies Buddhist tradition to twenty-first-century struggles in a relevant way. The result is a wise approach to dealing with human problems that is both optimistic and realistic, even in the most challenging times.\nHow can we expect to find happiness and meaning in our lives when the modern world seems such an unhappy place?\nHis Holiness the Dalai Lama has suffered enormously throughout his life, yet he always seems to be smiling and serene. How does he do it? In The Art of Happiness in a Troubled World, Dr. Cutler walks readers through the Dalai Lama's philosophy on how to achieve peace of mind and come to terms with life's inherent suffering. Together, the two examine the roots of many of the problems facing the world and show us how we can approach these calamities in a way that alleviates suffering, and helps us along in our personal quests to be happy. Through stories, meditations, and in-depth conversations, the Dalai Lama teaches readers to identify the cultural influences and ways of thinking that lead to personal unhappiness, making sense of the hardships we face personally, as well as the afflictions suffered by others.",
  price: 15.21,
  books_in_stock: rand(20..100),
  author_id: author.id,
  images: File.open(Rails.root + "app/assets/images/books-images/51KBQZS9L.jpg"))

  other_books[2] = FactoryGirl.create(:book,
  title: 'The Best Teachings Of The Dalai Lama: Journey To A Happy, Fulfilling & Meaningful Life',
  description: "Why is The Dalai Lama always smiling?\nI’m sure I’m not the only one who has asked myself this question. This is a man who has practically lost his country and is now living as the frugal exiled leader of the Tibetans. Why is he smiling? To us there is no logical reason for him to maintain such a sunny deposition – so why does he?\nIt’s called happiness!\nThis book explores the Dalai Lama’s teachings on how to achieve the happiness he displays so easily. Beneath the deepness of his words are concepts so easy to understand, you’ll wonder why you didn’t realize them before now.\nThis book will reveal:\nWhat true happiness really is\nWhy love and compassion are the entry points to happiness and how you can cultivate these concepts and apply them in your daily life\nThe things you might be doing that are causing you unhappiness and how to wean yourself off these habits gradually for a happier you\nWhat real wisdom is and how it affects your perception of your own suffering, other people and their actions and how to train your mind to reinterpret these events in the correct way\nWhy and how to cultivate mindfulness and incorporate meditation practices into your daily life and increase your enjoyment of your life right now as well.\nMuch, much more!\nThis book is for those who are genuinely seeking happiness.",
  price: 8.95,
  books_in_stock: rand(20..100),
  author_id: author.id,
  images: File.open(Rails.root + "app/assets/images/books-images/51N9CNkljL.jpg"))

  other_books[3] = FactoryGirl.create(:book,
  title: '365 Dalai Lama: Daily Advice from the Heart',
  description: "Imagine having an audience with the Dalai Lama every day, receiving personal advice about how to make your life better and more joyful.\n365 Dalai Lama offers exactly that: short and inspiring words offering enlightening advice for everyday living.\nThe teachings in 365 Dalai Lama offer an opportunity to feel the focus and presence of the Dalai Lama as never before. His holiness shares his advice from the heart on a variety of topics including:\nLiving and Growing Old\nYoung People and Families\nSickness and\nDying\nLiving in Poverty and Wealth\nAnger, Jealousy, Pride, and Desire\nReligion and Faith\nSexual Desire and Homosexuality\nWar and Politics\nMindfulness and a Contemplative Life",
  price: 13.38,
  books_in_stock: rand(20..100),
  author_id: author.id,
  images: File.open(Rails.root + "app/assets/images/books-images/51TX2yVUq0L.jpg"))

  other_books[4] = FactoryGirl.create(:book,
  title: 'Freedom in Exile: The Autobiography of The Dalai Lama',
  description: "In this astonishingly frank autobiography, the Dalai Lama reveals the remarkable inner strength that allowed him to master both the mysteries of Tibetan Buddhism and the brutal realities of Chinese Communism.",
  price: 14.36,
  books_in_stock: rand(20..100),
  author_id: author.id,
  images: File.open(Rails.root + "app/assets/images/books-images/51TxDaEbL._SX331_BO1,204,203,200_.jpg"))

  other_books[5] = FactoryGirl.create(:book,
  title: "The Dalai Lama's Little Book of Inner Peace: The Essential Life and Teachings",
  description: "His Holiness the Dalai Lama offers powerful, profound advice on how to live a peaceful and fulfilling life amidst all the conflicts of the modern world.\nIn this distillation of his life and teachings, the Dalai Lama paints a compelling portrait of his early life, reflecting on the personal and political struggles that have helped to shape his understanding of our world. Offering his wisdom and experience to interpret the timeless teachings of the Buddha, The Dalai Lama's Little Book of Inner Peace is fresh and relevant to our troubled times. He explains in a simple and accessible way how each of us can influence those around us by living with integrity. And he holds out hope that, through personal transformation, we can all contribute to a better world.",
  price: 12.28,
  books_in_stock: rand(20..100),
  author_id: author.id,
  images: File.open(Rails.root + "app/assets/images/books-images/61KPB4YQnRL.jpg"))

  other_books[6] = FactoryGirl.create(:book,
  title: "The Dalai Lama's Book of Wisdom",
  description: "The Dalai Lama provides simple advice on the importance of compassion and forgiveness.",
  price: 8.95,
  books_in_stock: rand(20..100),
  author_id: author.id,
  images: File.open(Rails.root + "app/assets/images/books-images/71-qtQ6xR1L.jpg"))

  other_category.books << other_books

  Book.all.each do |book|
    FactoryGirl.create_list :rating, rand(1..5), book_id: book.id, state: 'approved'
    FactoryGirl.create_list :rating, rand(1..5), book_id: book.id
  end

  rand(10..50).times do 
    order = FactoryGirl.build :order
    
    rand(1..3).times do
      order.order_items << FactoryGirl.build(:order_item, 
        book: Book.all.sample, order: order, quantity: rand(1..3))
    end

    order.order_items.each do |item|
      item.send(:update_price)
      item.save!
    end

    checkout_form = CheckoutForm.new(order)
    checkout_form.next_step = 'complete'
    checkout_form.valid?  
    checkout_form.save
  end
end